extends Node3D

@onready var game_platform: CSGBox3D
@onready var boss_music = $BossMusic
@onready var shop_music = $ShopMusic
var shop_timer: Timer
var platform_range: Array[float]
var shop_scene = preload("res://Scenes/shop.tscn")
var shop_instance
@export var OFFSET_FROM_WALL: float = 4.0
@export var SHOP_AD_TIME = 15.0
@export var SHOP_TIME_TO_SHOW = 5.0
@export var SHOP_RESPAWN_TIME = SHOP_AD_TIME + SHOP_TIME_TO_SHOW + 15.0
signal ad_appear_counter


enum Borders {
	MIN_X,
	MAX_X,
	MIN_Y,
	MAX_Y,
	MIN_Z,
	MAX_Z
}

func _ready():
	shop_timer = create_shop_timer()

func create_shop_timer() -> Timer:
	var new_shop_timer = Timer.new()
	new_shop_timer.wait_time = SHOP_RESPAWN_TIME - 30.0 # 30.0 as debug
	new_shop_timer.one_shot = false
	new_shop_timer.timeout.connect(open_shop)
	add_child(new_shop_timer)
	new_shop_timer.start()
	return new_shop_timer
	
func open_shop():
	boss_music.stream_paused = true
	if !shop_music.playing:
		shop_music.play()
	shop_music.stream_paused = false
	get_tree().create_timer(SHOP_AD_TIME).timeout.connect(
	func():
			boss_music.stream_paused = false
			shop_music.stream_paused = true,
		CONNECT_ONE_SHOT
	)
	shop_timer.paused = true # debug
	ad_appear_counter.emit()
	spawn_shop_area()
	
func spawn_shop_area():
	shop_instance = shop_scene.instantiate()
	platform_range = update_platform_range($platform)
	shop_instance.position = Vector3(
		randf_range(platform_range[Borders.MIN_X] + OFFSET_FROM_WALL,
					platform_range[Borders.MAX_X] - OFFSET_FROM_WALL),
		platform_range[Borders.MAX_Y],
		randf_range(platform_range[Borders.MIN_Z] + OFFSET_FROM_WALL,
					platform_range[Borders.MAX_Z] - OFFSET_FROM_WALL)
	)
	add_child(shop_instance)
	var player = get_tree().get_first_node_in_group("player")
	shop_instance.player_immunity.connect(player.player_immunity)

func update_platform_range(platform: CSGBox3D) -> Array[float]:
	var middle = platform.global_position
	var half = platform.size / 2
	var min_x = middle.x - half.x
	var max_x = middle.x + half.x
	var min_y = middle.y - half.y
	var max_y = middle.y + half.y
	var min_z = middle.z - half.z
	var max_z = middle.z + half.z
	return [min_x, max_x, min_y, max_y, min_z, max_z]
