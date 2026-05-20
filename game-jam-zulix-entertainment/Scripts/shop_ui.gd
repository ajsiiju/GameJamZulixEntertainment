extends Control

var timer_to_show_shop: float = 5.0
var timer_to_exit_shop: float = 0.0
@export var SHOP_VISIBILITY_TIME: float  = 15.0
signal unlock_skill(skill_number)

func _ready() -> void:
	visible = false
	set_process(false)
	var main = get_tree().get_first_node_in_group("main")
	main.ad_appear_counter.connect(ad_appear_counter)
	$shop_bg/exit_button.pressed.connect(on_exit_button)
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
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			visible = false
			timer_to_show_shop = 5.0
			timer_to_exit_shop = 0.0
			set_process(false)
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			visible = true
			timer_to_exit_shop += delta
			$shop_bg/ProgressBar.value = timer_to_exit_shop
		
func on_exit_button():
	get_tree().quit()

func buy_skill(skill_number: int):
	unlock_skill.emit(skill_number)
	get_viewport().gui_release_focus()
	
