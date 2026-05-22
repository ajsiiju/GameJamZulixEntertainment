extends Control

var timer_to_show_shop: float = 5.0
var timer_to_exit_shop: float = 0.0
@export var SHOP_VISIBILITY_TIME: float  = 15.0
@onready var boss_music = $BossMusic
@onready var shop_music = $ShopMusic
const DUCK_RUN_TIME: float = 6.0
const duck_scene = preload("res://Scenes/duck.tscn")
var shop_scene = preload("res://Scenes/tungtung.tscn")
signal unlock_skill(skill_number)
signal move_social_points(move_position)
var platform_range: Array[float]
@export var OFFSET_FROM_WALL: float = 4.0
enum Borders {
	MIN_X,
	MAX_X,
	MIN_Y,
	MAX_Y,
	MIN_Z,
	MAX_Z
}

func _ready() -> void:
	visible = false
	set_process(false)
	var main = get_tree().get_first_node_in_group("main")
	main.ad_appear_counter.connect(ad_appear_counter)
	$shop_bg/exit_button.pressed.connect(on_exit_button)
	$shop_bg/DownloadButton.pressed.connect(malpka_appears)
	$shop_bg/duck_button.pressed.connect(duck_appears)
	$shop_bg/tungtung_button.pressed.connect(tungtung_appears)
	$shop_bg/skill_offer1/buy_button1.pressed.connect(func(): buy_skill(1))
	$shop_bg/skill_offer2/buy_button1.pressed.connect(func(): buy_skill(2))
	$shop_bg/skill_offer3/buy_button1.pressed.connect(func(): buy_skill(3))
	$shop_bg/skill_offer4/buy_button1.pressed.connect(func(): buy_skill(4))

func ad_appear_counter():
	timer_to_show_shop = 5.0
	set_process(true)

func _process(delta: float) -> void:
	timer_to_show_shop -= delta
	if timer_to_show_shop <= 0:
		if timer_to_exit_shop >= SHOP_VISIBILITY_TIME:
			shop_hide()
			boss_music.stream_paused = false
			shop_music.stream_paused = true
		else:
			timer_to_exit_shop += delta
			$shop_bg/ProgressBar.value = timer_to_exit_shop
			shop_show()
			if !shop_music.playing:
				shop_music.play()
			boss_music.stream_paused = true
			shop_music.stream_paused = false
		
func on_exit_button():
	get_tree().quit()

func buy_skill(skill_number: int):
	unlock_skill.emit(skill_number)
	get_viewport().gui_release_focus()
	
func shop_hide():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
	timer_to_show_shop = 5.0
	timer_to_exit_shop = 0.0
	move_social_points.emit("corner")
	set_process(false)
	
func shop_show():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visible = true
	move_social_points.emit("middle")
	
func duck_appears():
	shop_hide()
	var duck_instance = duck_scene.instantiate()
	duck_instance.scale = Vector2(0.20, 0.20)
	var duck_size = duck_instance.size * duck_instance.scale
	get_parent().get_node("HUD").add_child(duck_instance)
	
	var viewport_size = get_viewport().get_visible_rect().size
	duck_instance.global_position = Vector2(
		viewport_size.x - duck_size.x - -100 +70,
		viewport_size.y - duck_size.y - -60 +100
	)
	
	var target_position = Vector2(-100, -60)
	var tween = create_tween()
	tween.tween_property(duck_instance, "global_position", target_position, DUCK_RUN_TIME)
	
	get_tree().create_timer(DUCK_RUN_TIME/2).timeout.connect(
	func():
			%Crosshair.reparent(duck_instance, false)
			%Crosshair.position = Vector2(-70,-100)
			%Crosshair.scale = Vector2(5.0, 5.0)
			duck_instance.move_child(%Crosshair, 0)
			var player = get_tree().get_first_node_in_group("player")
			player.get_node("CameraRig").is_broken_camera = true,
		CONNECT_ONE_SHOT
	)

func malpka_appears():
	shop_hide()
	var malpka = get_parent().get_node("Malpka")
	malpka.activate_malpka()

func tungtung_appears():
	shop_hide()
	var platform = get_node("/root/Node3D/platform")
	for i in range(500):
		var tungtung_instance = shop_scene.instantiate()
		platform_range = update_platform_range(platform)
		tungtung_instance.position = Vector3(
			randf_range(platform_range[Borders.MIN_X] + OFFSET_FROM_WALL,
						platform_range[Borders.MAX_X] - OFFSET_FROM_WALL),
			randf_range(platform_range[Borders.MAX_Y], platform_range[Borders.MAX_Y] + 30) ,
			randf_range(platform_range[Borders.MIN_Z] + OFFSET_FROM_WALL,
						platform_range[Borders.MAX_Z] - OFFSET_FROM_WALL)
		)
		add_child(tungtung_instance)
	
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
