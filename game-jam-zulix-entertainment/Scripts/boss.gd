extends Node3D

@onready var boss_2: Timer = $Boss2
@onready var boss_3: Timer = $Boss3
@onready var boss_4: Timer = $Boss4
@onready var boss_5: Timer = $Boss5
@onready var boss_6: Timer = $Boss6

@onready var boss: TextureRect = $Sprite3D/SubViewport/boss



var current_boss = ""

#kiedy użyje sie stuna sprawdza który boss i zatrzymuje jego timery ataków na 3s i z powrotem wznawia
#if current_boss == "":
#pass


#FALA
@onready var ray_wave: RayCast3D = $RayWave
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
@onready var timer_grass: Timer = $TimerGrass
var grass = load("res://Scenes/grass.tscn")
var grass_instance = null
var prev_grass_instance = null

#CAT AND DOG
@onready var timer_cat_and_dog: Timer = $TimerCatAndDog
var cat_dog_scene = load("res://Scenes/cat_dog_follow.tscn")
@onready var cat_dog_instance = null


#PALKA PION
@onready var timer_palka_pion: Timer = $TimerPalkaPion
var palka_scene = load("res://Scenes/palka.tscn")
var palka_pion_amount = 1
var palka_pion_instance = null


#PALKA POZIOM
@onready var timer_palka_poziom: Timer = $TimerPalkaPoziom
var palka_poziom_instance = null


#CHOCOLATE
@onready var timer_chocolate: Timer = $TimerChocolate
@onready var timer_chocolate_change_fast: Timer = $TimerChocolateChangeFast
@onready var timer_chocolate_change_slow: Timer = $TimerChocolateChangeSlow

var chocolate_scene = load("res://Scenes/chocolate.tscn")
var chocolate_instance = null


#MATCHA
@onready var timer_matcha: Timer = $TimerMatcha
var matcha_scene = load("res://Scenes/matcha.tscn")
var matcha_instance = null


#ROBLOX BULLET
@onready var timer_roblox_bullet: Timer = $TimerRobloxBullet
var roblox_bullet_scene = load("res://Scenes/roblox_bullet.tscn")
var roblox_bullet_instance = null
@onready var ray_roblox_bullet: RayCast3D = $RayRobloxBullet


#ROBLOX BALLS


func _ready() -> void:
	boss.texture = null

#FALA
func _on_timer_wave_bullets_timeout() -> void:
	while wave_bullet_amount <= 50:
		instance = bullet.instantiate()
		instance.position = ray_wave.global_position
		instance.position.x -= wave_bullet_position
		wave_bullet_position += 1
		wave_bullet_amount += 1
		get_parent().add_child(instance)
	wave_bullet_amount = 1
	wave_bullet_position = 0.0
	
	var rand_time = rng.randf_range(3.0, 5.0)
	timer_wave_bullets.wait_time = rand_time



#POP_UP WINDOW
func _on_timer_pop_up_window_timeout() -> void:
	var rand_position_x = rng.randf_range(85.0, 1455.0)
	var rand_position_y = rng.randf_range(65.0, 515.0)
	pop_up_instance = pop_up_window.instantiate()
	pop_up_instance.position = Vector2(rand_position_x, rand_position_y)
	get_parent().add_child(pop_up_instance)
	if prev_pop_up_instance:
		prev_pop_up_instance.queue_free()
	prev_pop_up_instance = pop_up_instance

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


func _on_boss_1_timeout() -> void:
	timer_wave_bullets.stop()
	if get_parent().has_node("boss_bullet"):
		instance.queue_free()
	
	timer_pop_up_window.stop()
	if get_parent().has_node("job_aplication_pop_up_window"):
		pop_up_instance.queue_free()
	boss_2.start()
	
	timer_grass.start()
	timer_cat_and_dog.start()
	boss.texture = load("res://Assets/Characters/Bosses/maklowicz_idle.png")



#GRASS
func _on_timer_grass_timeout() -> void:
	grass_instance = grass.instantiate()
	var rand_position_x = rng.randf_range(25.0, -20.0)
	var rand_position_z = rng.randf_range(15.0, -20.0)
	grass_instance.position = Vector3(rand_position_x, -0.858, rand_position_z)
	get_parent().add_child(grass_instance)
	
	var transitionTween = create_tween()
	transitionTween.tween_property(grass_instance, "position:y", -0.436, 0.5)
	
	if prev_grass_instance:
		prev_grass_instance.queue_free()
	prev_grass_instance = grass_instance
	boss.texture = load("res://Assets/Characters/Bosses/maklowicz_attack.png")
	await get_tree().create_timer(0.2).timeout
	boss.texture = load("res://Assets/Characters/Bosses/maklowicz_idle.png")



#CAT AND DOG FOLLOW
func _on_timer_cat_and_dog_timeout() -> void:
	cat_dog_instance = cat_dog_scene.instantiate()
	cat_dog_instance.position = Vector3(0, 0, 15.822)
	get_parent().add_child(cat_dog_instance)
	boss.texture = load("res://Assets/Characters/Bosses/maklowicz_attack.png")
	await get_tree().create_timer(0.2).timeout
	boss.texture = load("res://Assets/Characters/Bosses/maklowicz_idle.png")



func _on_boss_2_timeout() -> void:
	timer_grass.stop()
	if get_parent().has_node("grass"):
		grass_instance.queue_free()
	
	timer_cat_and_dog.stop()
	if get_parent().has_node("cat_dog_follow"):
		cat_dog_instance.queue_free()
	
	boss_3.start()
	
	timer_palka_pion.start()
	timer_palka_poziom.start()
	boss.texture = null



#PALKA PION
func _on_timer_palka_pion_timeout() -> void:
	boss.texture = null
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
	boss.texture = null
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



func _on_boss_3_timeout() -> void:
	timer_palka_poziom.stop()
	if get_parent().has_node("palka"):
		palka_pion_instance.queue_free()
	
	timer_palka_pion.stop()
	if get_parent().has_node("palka"):
		palka_poziom_instance.queue_free()
	
	boss_4.start()
	
	timer_chocolate.start()
	timer_chocolate_change_fast.start()
	timer_matcha.start()
	boss.texture = load("res://Assets/Characters/Bosses/labubu_idle.png")



#CHOCOLATE
@onready var player = get_parent().get_node("player")

func _on_timer_chocolate_timeout() -> void:
	DebugChat.message("zaczelo sie")
	boss.texture = load("res://Assets/Characters/Bosses/labubu_attack.png")
	
	var chocolate_instance = chocolate_scene.instantiate()
	get_tree().current_scene.add_child(chocolate_instance)
	chocolate_instance.global_position = global_position + Vector3(0, 5, 0)
	var player_position = player.global_position
	chocolate_instance.set_target_position(player_position)
	
	await get_tree().create_timer(0.1).timeout
	boss.texture = load("res://Assets/Characters/Bosses/labubu_idle.png")

func _on_timer_chocolate_change_fast_timeout() -> void:
	timer_chocolate.wait_time = 0.2
	timer_chocolate_change_slow.start()

func _on_timer_chocolate_change_slow_timeout() -> void:
	timer_chocolate.wait_time = 0.5
	timer_chocolate_change_fast.start()



#MATCHA
func _on_timer_matcha_timeout() -> void:
	matcha_instance = matcha_scene.instantiate()
	get_tree().current_scene.add_child(matcha_instance)
	matcha_instance.global_position = global_position + Vector3(0, 5, 0)
	
	var rand_pos_x = rng.randf_range(25.0, -20.0)
	var pos_y = -0.141
	var rand_pos_z = rng.randf_range(15.0, -20.0)
	
	var tween = create_tween()
	tween.tween_property(matcha_instance, "position", Vector3(rand_pos_x, pos_y, rand_pos_z), 0.7)



func _on_boss_4_timeout() -> void:
	timer_chocolate.stop()
	if get_parent().has_node("chocolate"):
		chocolate_instance.queue_free()
	
	timer_matcha.stop()
	if get_parent().has_node("matcha"):
		matcha_instance.queue_free()
	
	boss_5.start()
	
	timer_roblox_bullet.start()
	#timer_matcha.start()
	boss.texture = null



#ROBLOX BULLET
func _on_timer_roblox_bullet_timeout() -> void:
	roblox_bullet_instance = bullet.instantiate()
	roblox_bullet_instance.position = ray_roblox_bullet.global_position
	
	var rand_pos_x = rng.randf_range(25.0, -20.0)
	roblox_bullet_instance.position.x = rand_pos_x
	
	get_parent().add_child(roblox_bullet_instance)



#ROBLOX BALLS
