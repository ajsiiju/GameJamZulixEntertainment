extends Control


var text: String = "Please enter your credit card number:"
var current_index = 0
var timer = 0.0
var letter_delay = 0.1
var text_complete = false
var timer_started: bool = false
@onready var label = $Dialog/Label
@onready var malpka = $Malpka

func _ready() -> void:
	set_process(false)
	visible = false

func _process(delta: float) -> void:
	if text_complete:
		if !timer_started:
			timer_started = true
			get_tree().create_timer(3.0).timeout.connect(
			func():
					get_tree().change_scene_to_file("res://Scenes/crash.tscn"),
				CONNECT_ONE_SHOT
			)
		else:
			return
		
	timer += delta
	
	if timer >= letter_delay and current_index < text.length():
		timer = 0.0
		label.text = label.text.substr(0, label.text.length() - 1)
		label.text += text[current_index] + "_"
		current_index += 1
		
		if current_index >= text.length():
			text_complete = true
			
func activate_malpka():
	malpka.texture.set_current_frame(0)
	set_process(true)
	visible = true
