extends Node3D

#FALA
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var timer_wave_bullets: Timer = $TimerWaveBullets
var bullet  = load("res://Scenes/boss_bullet.tscn")
var instance
var wave_bullet_amount = 1
var wave_bullet_position = 0.0

#POP_UP WINDOW
@onready var timer_pop_up_window: Timer = $TimerPopUpWindow
var pop_up_window = load("res://Scenes/job_aplication_pop_up_window.tscn")
var last_pressed_key = ""
var current_pressed_key = ""
var pop_up_instance = null
var prev_pop_up_instance = null
var rng = RandomNumberGenerator.new()

#GRASS
@onready var boss_2: Timer = $Boss2
@onready var timer_grass: Timer = $TimerGrass
var grass = load("res://Scenes/grass.tscn")
var grass_instance = null
var prev_grass_instance = null

#CAT AND DOG
@onready var timer_cat_and_dog: Timer = $TimerCatAndDog
var cat_dog_scene = load("res://Scenes/cat_dog_follow.tscn")
@onready var cat_dog_instance = null


#PALKA PION
@onready var boss_3: Timer = $Boss2
@onready var timer_palka_pion: Timer = $TimerPalkaPion
var palka_scene = load("res://Scenes/palka.tscn")
var palka_pion_amount = 1
var palka_pion_instance = null



#PALKA POZIOM
@onready var timer_palka_poziom: Timer = $TimerPalkaPoziom
var palka_poziom_instance = null


#FALA
#func _on_timer_wave_bullets_timeout() -> void:
	#while wave_bullet_amount <= 50:
		#instance = bullet.instantiate()
		#instance.position = ray_cast_3d.global_position
		#instance.position.x -= wave_bullet_position
		#wave_bullet_position += 1
		#wave_bullet_amount += 1
		#get_parent().add_child(instance)
	#wave_bullet_amount = 1
	#wave_bullet_position = 0.0
#
#
#
##POP_UP WINDOW
#func _on_timer_pop_up_window_timeout() -> void:
	#var rand_position_x = rng.randf_range(85.0, 1455.0)
	#var rand_position_y = rng.randf_range(65.0, 515.0)
	#pop_up_instance = pop_up_window.instantiate()
	#pop_up_instance.position = Vector2(rand_position_x, rand_position_y)
	#get_parent().add_child(pop_up_instance)
	#if prev_pop_up_instance:
		#prev_pop_up_instance.queue_free()
	#prev_pop_up_instance = pop_up_instance
#
#func _input(event: InputEvent) -> void:
	#if pop_up_instance != null:
		#if event.is_pressed() and not event is InputEventMouseMotion:
			#if event is InputEventKey and event.pressed and not event.is_echo():
				#current_pressed_key = OS.get_keycode_string(event.keycode)
			#
			#
			#if current_pressed_key != last_pressed_key:
				#var progress_bar = pop_up_instance.get_node("ProgressBar")
				#
				#if progress_bar:
					#progress_bar.value += 1
					#if progress_bar.value >= progress_bar.max_value:
						#pop_up_instance.queue_free()
						#pop_up_instance = null
	#
	#last_pressed_key = current_pressed_key
#
#
#func _on_boss_1_timeout() -> void:
	#timer_wave_bullets.stop()
	#timer_pop_up_window.stop()
	#boss_2.start()
	#timer_grass.start()
	#timer_cat_and_dog.start()
#
#
#
##GRASS
#func _on_timer_grass_timeout() -> void:
	#grass_instance = grass.instantiate()
	#var rand_position_x = rng.randf_range(25.0, -20.0)
	#var rand_position_z = rng.randf_range(15.0, -20.0)
	#grass_instance.position = Vector3(rand_position_x, -0.858, rand_position_z)
	#get_parent().add_child(grass_instance)
	#
	#var transitionTween = create_tween()
	#transitionTween.tween_property(grass_instance, "position:y", -0.436, 0.5)
	#
	#if prev_grass_instance:
		#prev_grass_instance.queue_free()
	#prev_grass_instance = grass_instance
#
#
#
##CAT AND DOG FOLLOW
#func _on_timer_cat_and_dog_timeout() -> void:
	#cat_dog_instance = cat_dog_scene.instantiate()
	#cat_dog_instance.position = Vector3(0, 0, 15.822)
	#get_parent().add_child(cat_dog_instance)
#
#
#func _on_boss_2_timeout() -> void:
	#timer_grass.stop()
	#timer_cat_and_dog.stop()
	#boss_3.start()
	#timer_palka_pion.start()
	#timer_palka_poziom.start()


#PALKA PION
func _on_timer_palka_pion_timeout() -> void:
	while palka_pion_amount <= 5:
		palka_pion_instance = palka_scene.instantiate()
		var rand_position_x = rng.randf_range(15.0, -15.0)
		palka_pion_instance.position = Vector3(rand_position_x, -0.182, 15.94)
		get_parent().add_child(palka_pion_instance)
		
		var x_degrees = -90
		var rotation_x = deg_to_rad(x_degrees)
		var tween = create_tween()
		tween.tween_property(palka_pion_instance, "rotation:x", rotation_x, 0.5).set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)         
		
		await get_tree().create_timer(0.6).timeout
		
		palka_pion_instance.queue_free()
		palka_pion_amount += 1
		await get_tree().create_timer(0.8).timeout
	palka_pion_amount = 1


#PALKA POZIOM
func _on_timer_palka_poziom_timeout() -> void:
	palka_poziom_instance = palka_scene.instantiate()
	palka_poziom_instance.position = Vector3(0, -0.182, 15.94)
	get_parent().add_child(palka_poziom_instance)
	
	var z_degrees = -90
	var rotation_z = deg_to_rad(z_degrees)
	var tween = create_tween()
	tween.tween_property(palka_poziom_instance, "rotation:z", rotation_z, 0.5).set_trans(Tween.TRANS_QUAD)\
	.set_ease(Tween.EASE_IN)  
	
	await get_tree().create_timer(0.6).timeout
	
	var y_degrees = 180
	var rotation_y = deg_to_rad(y_degrees)
	tween = create_tween()
	tween.tween_property(palka_poziom_instance, "rotation:y", rotation_y, 1)
	
	await get_tree().create_timer(1).timeout
	palka_poziom_instance.queue_free()
