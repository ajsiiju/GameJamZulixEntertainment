extends Node3D

#FALA
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var timer_wave_bullets: Timer = $TimerWaveBullets
var bullet  = load("res://Scenes/boss_bullet.tscn")
var instance
var pop_up_instance = null
var wave_bullet_amount = 1
var wave_bullet_position = 0.0


func _on_timer_wave_bullets_timeout() -> void:
	while wave_bullet_amount <= 50:
		instance = bullet.instantiate()
		instance.position = ray_cast_3d.global_position
		instance.position.x -= wave_bullet_position
		wave_bullet_position += 1
		wave_bullet_amount += 1
		get_parent().add_child(instance)
	wave_bullet_amount = 1
	wave_bullet_position = 0.0



#POP_UP WINDOW
var pop_up_window = load("res://Scenes/job_aplication_pop_up_window.tscn")
@onready var timer_pop_up_window: Timer = $TimerPopUpWindow
var last_pressed_key = ""
var current_pressed_key = ""
var prev_pop_up = null
var rng = RandomNumberGenerator.new()


func _on_timer_pop_up_window_timeout() -> void:
	var rand_position_x = rng.randf_range(85.0, 1455.0)
	var rand_position_y = rng.randf_range(65.0, 515.0)
	pop_up_instance = pop_up_window.instantiate()
	pop_up_instance.position = Vector2(rand_position_x, rand_position_y)
	get_parent().add_child(pop_up_instance)
	if prev_pop_up:
		prev_pop_up.queue_free()
	prev_pop_up = pop_up_instance

func _input(event: InputEvent) -> void:
	if pop_up_instance != null:
		if event.is_pressed() and not event is InputEventMouseMotion:
			if event is InputEventKey and event.pressed and not event.is_echo():
				current_pressed_key = OS.get_keycode_string(event.keycode)
			
			
			if current_pressed_key != last_pressed_key:
				var progress_bar = pop_up_instance.get_node("ProgressBar")
				
				if progress_bar:
					progress_bar.value += 1
					if progress_bar.value >= progress_bar.max_value:
						pop_up_instance.queue_free()
						pop_up_instance = null
	
	last_pressed_key = current_pressed_key

#GRASS
@onready var timer_grass: Timer = $TimerGrass

func _on_timer_grass_appear_timeout() -> void:
	timer_grass.start()
