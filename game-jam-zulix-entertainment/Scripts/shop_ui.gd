extends Control

var timer_to_show_shop: float = 5.0
var timer_to_exit_shop: float = 0.0
@export var SHOP_VISIBILITY_TIME: float  = 15.0
const DUCK_RUN_TIME: float = 6.0
const duck_scene = preload("res://scenes/duck.tscn")
signal unlock_skill(skill_number)
signal move_social_points(move_position)

func _ready() -> void:
	visible = false
	set_process(false)
	var main = get_tree().get_first_node_in_group("main")
	main.ad_appear_counter.connect(ad_appear_counter)
	$shop_bg/exit_button.pressed.connect(on_exit_button)
	$shop_bg/DownloadButton.pressed.connect(duck_appears)
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
		else:
			timer_to_exit_shop += delta
			$shop_bg/ProgressBar.value = timer_to_exit_shop
			shop_show()

		
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
