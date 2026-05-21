extends Node3D

@onready var boss_1: Timer = $Boss1
var player
var target_health: float = 1000.0
var visible_health: float = 1000.0
const MAX_HEALTH: float = 1000.0
const HEALTH_REGEN_PER_FRAME: float = 0.02

@onready var boss_2: Timer = $Boss2
@onready var boss_3: Timer = $Boss3
@onready var boss_4: Timer = $Boss4
@onready var boss_5: Timer = $Boss5
@onready var boss_6: Timer = $Boss6

@onready var round_timer: Timer = $TimerBoss

@onready var boss: TextureRect = $Sprite3D/SubViewport/boss
@onready var telefon_bg: TextureRect = $Sprite3D/SubViewport/telefonBg
@onready var hurt_audio: AudioStreamPlayer3D = $HurtAudio

#boss 1 - job apl
#boss 2 - makłowicz
#boss 3 - tung
#boss 4 - labubu
#boss 5 - roblox
#boss 6 - bober


#LOSOWANIE BOSÓW
var max_random_number = 5
var boss_amount = 0
var boss_array = ["boss1", "boss2", "boss3", "boss4", "boss5", "boss6"]
var boss_order_array = []
var current_boss_number = 0
var previous_boss_array = current_boss_number - 1
var current_boss_array = null
var next_boss_array = current_boss_number + 1

func _process(_delta: float) -> void:
	visible_health= lerp(visible_health, target_health, HEALTH_REGEN_PER_FRAME)

func change_health(health_difference):
	target_health += health_difference
	target_health = clamp(target_health, 0.0, MAX_HEALTH)
	if health_difference < 0.0:
		hurt_audio.play()
		player.change_social_points(10)
	if target_health <= 0.0:
		get_tree().change_scene_to_file("res://Scenes/game_won.tscn")
	

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	while boss_amount < 6:
		var random_number = rng.randi_range(0, max_random_number)
		max_random_number -= 1
		boss_amount += 1
		var selected_boss = boss_array[random_number]
		boss_order_array.append(selected_boss)
		boss_array.remove_at(random_number)
	
	play_next_boss()


func play_next_boss() -> void:
	if current_boss_number > 0:
		var previous_boss_name = boss_order_array[current_boss_number - 1]
		stop_boss_by_name(previous_boss_name)
		
	if current_boss_number >= boss_order_array.size():
#		#GAMEOVER SCREEN
		return

	current_boss_array = boss_order_array[current_boss_number]
	start_boss_by_name(current_boss_array)
	
	round_timer.start()
		
	current_boss_number += 1


func start_boss_by_name(boss_name: String) -> void:
	match boss_name:
		"boss1": boss_1_start(); current_boss = 1
		"boss2": boss_2_start(); current_boss = 2
		"boss3": boss_3_start(); current_boss = 3
		"boss4": boss_4_start(); current_boss = 4
		"boss5": boss_5_start(); current_boss = 5
		"boss6": boss_6_start(); current_boss = 6

func stop_boss_by_name(boss_name: String) -> void:
	match boss_name:
		"boss1": boss_1_stop()
		"boss2": boss_2_stop()
		"boss3": boss_3_stop()
		"boss4": boss_4_stop()
		"boss5": boss_5_stop()
		"boss6": boss_6_stop()

func _on_timer_boss_timeout() -> void:
	play_next_boss()

var current_boss = 1

func boss_stun() -> void:
	match current_boss:
		1:
			timer_wave_bullets.stop()
			timer_pop_up_window.stop()
			await get_tree().create_timer(5).timeout
			timer_wave_bullets.start()
			timer_pop_up_window.start()
		2:
			timer_grass.stop()
			timer_cat_and_dog.stop()
			await get_tree().create_timer(5).timeout
			timer_grass.start()
			timer_cat_and_dog.start()
		3:
			timer_palka_pion.stop()
			timer_palka_poziom.stop()
			await get_tree().create_timer(5).timeout
			timer_palka_pion.start()
			timer_palka_poziom.start()
		4:
			timer_chocolate.stop()
			timer_chocolate_change_fast.stop()
			timer_matcha.stop()
			await get_tree().create_timer(5).timeout
			timer_chocolate.start()
			timer_chocolate_change_fast.start()
			timer_matcha.start()
		5:
			timer_roblox_bullet.stop()
			timer_roblox_balls.stop()
			await get_tree().create_timer(5).timeout
			timer_roblox_bullet.start()
			timer_roblox_balls.start()
		6:
			timer_gravity_pull.stop()
			timer_bober_bullets.stop()
			await get_tree().create_timer(5).timeout
			timer_gravity_pull.start()
			timer_bober_bullets.start()



func boss_1_start() -> void:
	timer_wave_bullets.start()
	timer_pop_up_window.start()
	
	boss_anim_sprites.visible = false
	boss.texture = load("res://Assets/Characters/Bosses/job_apl.jpg")
	telefon_bg.texture = load("res://Assets/Characters/Bosses/tel_bg2.png")

func boss_1_stop() -> void:
	timer_wave_bullets.stop()
	if get_parent().has_node("boss_bullet"):
		instance.queue_free()
	
	timer_pop_up_window.stop()
	if get_parent().has_node("job_aplication_pop_up_window"):
		pop_up_instance.queue_free()
	
	telefon_bg.texture = load("res://Assets/Characters/Bosses/tel_bg.png")
	boss.texture = null


func boss_2_start() -> void:
	timer_grass.start()
	timer_cat_and_dog.start()
	
	boss_anim_sprites.visible = false
	boss.texture = load("res://Assets/Characters/Bosses/maklowicz_idle.png")


func boss_2_stop() -> void:
	timer_grass.stop()
	
	timer_cat_and_dog.stop()
	if get_parent().has_node("cat_dog_follow"):
		cat_dog_instance.queue_free()
	
	boss.texture = null


func boss_3_start() -> void:
	timer_palka_pion.start()
	timer_palka_poziom.start()
	
	boss_anim_sprites.stop()
	boss.texture = null
	boss_anim_sprites.visible = true
	boss_anim_sprites.play("tung_idle")

func boss_3_stop() -> void:
	timer_palka_poziom.stop()
	if get_parent().has_node("palka_poziom"):
		palka_poziom_instance.queue_free()
	
	timer_palka_pion.stop()
	
	boss_anim_sprites.visible = false
	boss_anim_sprites.stop()


func boss_4_start() -> void:
	timer_chocolate.start()
	timer_chocolate_change_fast.start()
	timer_matcha.start()
	
	boss_anim_sprites.visible = false
	boss.texture = load("res://Assets/Characters/Bosses/labubu_idle.png")

func boss_4_stop() -> void:
	timer_chocolate.stop()
	if get_parent().has_node("chocolate"):
		chocolate_instance.queue_free()
	
	timer_matcha.stop()
	if get_parent().has_node("matcha"):
		matcha_instance.queue_free()
	
	boss.texture = null


func boss_5_start() -> void:
	timer_roblox_bullet.start()
	timer_roblox_balls.start()
	
	boss_anim_sprites.stop()
	boss.texture = null
	boss_anim_sprites.visible = true
	boss_anim_sprites.play("roblox_robux")

func boss_5_stop() -> void:
	timer_roblox_bullet.stop()
	if get_parent().has_node("roblox_bullet"):
		roblox_bullet_instance.queue_free()
	
	timer_roblox_balls.stop()
	if get_parent().has_node("roblox_balls"):
		roblox_balls_instance.queue_free()
	
	boss_anim_sprites.visible = false
	boss_anim_sprites.stop()


func boss_6_start() -> void:
	timer_gravity_pull.start()
	timer_bober_bullets.start()
	
	boss_anim_sprites.stop()
	boss.texture = null
	boss_anim_sprites.visible = true
	boss_anim_sprites.play("bober_idle")

func boss_6_stop() -> void:
	timer_gravity_pull.stop()
	if get_parent().has_node("gravity_pull"):
		gravity_pull_instance.queue_free()
	
	timer_bober_bullets.stop()
	if get_parent().has_node("bober_bullets"):
		bober_bullet_instance.queue_free()
	
	boss_anim_sprites.visible = false
	boss_anim_sprites.stop()



#BACKUP
	#print(boss_order_array)
	#print(current_boss_number)
	#print(previous_boss_array)
	#print(next_boss_array)
	#current_boss_array = boss_order_array[current_boss_number]
	#previous_boss_array = current_boss_number - 1
	#next_boss_array = current_boss_number + 1
	#which_boss_start()
	#which_boss_timer()


#func which_boss_start() -> void:
	#match current_boss_array:
		#"boss1":
			#boss_1_start()
			#current_boss = 1
		#"boss2":
			#boss_2_start()
			#current_boss = 2
		#"boss3":
			#boss_3_start()
			#current_boss = 3
		#"boss4":
			#boss_4_start()
			#current_boss = 4
		#"boss5":
			#boss_5_start()
			#current_boss = 5
		#"boss6":
			#boss_6_start()
			#current_boss = 6
#
#func which_boss_stop() -> void:
	#match previous_boss_array:
		#"boss1":
			#boss_1_stop()
			#current_boss_number += 1
			#which_boss_timer()
		#"boss2":
			#boss_2_stop()
			#current_boss_number += 1
			#which_boss_timer()
		#"boss3":
			#boss_3_stop()
			#current_boss_number += 1
			#which_boss_timer()
		#"boss4":
			#boss_4_stop()
			#current_boss_number += 1
			#which_boss_timer()
		#"boss5":
			#boss_5_stop()
			#current_boss_number += 1
			#which_boss_timer()
		#"boss6":
			#boss_6_stop()
			#current_boss_number += 1
			#which_boss_timer()
#
#func which_boss_timer() -> void:
	#match next_boss_array:
		#"boss1":
			#boss_1.start()
		#"boss2":
			#boss_2.start()
		#"boss3":
			#boss_3.start()
		#"boss4":
			#boss_4.start()
		#"boss5":
			#boss_5.start()
		#"boss6":
			#boss_6.start()


#func _on_round_timer_timeout() -> void:
	#play_next_boss()


#func start_timer_by_name(boss_name: String) -> void:
	#match boss_name:
		#"boss1": boss_1.start()
		#"boss2": boss_2.start()
		#"boss3": boss_3.start()
		#"boss4": boss_4.start()
		#"boss5": boss_5.start()
		#"boss6": boss_6.start()


#func _ready() -> void:
	#boss.texture = load("res://Assets/Characters/Bosses/job_apl.jpg")
	#telefon_bg.texture = load("res://Assets/Characters/Bosses/tel_bg2.png")



#func _on_boss_1_timeout() -> void:
	#play_next_boss()
	##which_boss_start()
	##which_boss_stop()
	##which_boss_timer()
	##print(current_boss_number)
	##print(previous_boss_array)
	##print(next_boss_array)
	#
	##boss_2_start()
	##boss_2.start()
	##current_boss = 2
	##boss_2_stop()
#
#
#func _on_boss_2_timeout() -> void:
	#play_next_boss()
	##which_boss_timer()
	##which_boss_start()
	##which_boss_stop()
	##print(current_boss_number)
	##print(previous_boss_array)
	##print(next_boss_array)
	#
	##boss_3_start()
	##boss_3.start()
	##current_boss = 3
	##boss_3_stop()
#
#
#func _on_boss_3_timeout() -> void:
	#play_next_boss()
	##which_boss_timer()
	##which_boss_start()
	##which_boss_stop()
	##print(current_boss_number)
	##print(previous_boss_array)
	##print(next_boss_array)
	#
	##boss_4_start()
	##boss_4.start()
	##current_boss = 4
	##boss_4_stop()
#
#
#func _on_boss_4_timeout() -> void:
	#play_next_boss()
	##which_boss_timer()
	##which_boss_start()
	##which_boss_stop()
	##print(current_boss_number)
	##print(previous_boss_array)
	##print(next_boss_array)
	#
	##boss_5_start()
	##boss_5.start()
	##current_boss = 5
	##boss_5_stop()
#
#
#func _on_boss_5_timeout() -> void:
	#play_next_boss()
	##which_boss_timer()
	##which_boss_start()
	##which_boss_stop()
	##print(current_boss_number)
	##print(previous_boss_array)
	##print(next_boss_array)
	#
	##boss_6_start()
	##boss_6.start()
	##current_boss = 6
	##boss_6_stop()
#
#func _on_boss_6_timeout() -> void:
	#play_next_boss()
	#
	##which_boss_timer()
	##which_boss_start()
	##which_boss_stop()
	##print(current_boss_number)
	##print(previous_boss_array)
	##print(next_boss_array)
	#
	##screen with game over






@onready var boss_anim_sprites: AnimatedSprite2D = $Sprite3D/SubViewport/BossAnimSprites
#FALA
@export var job_apl_recource: JobAplResource
@onready var ray_wave: RayCast3D = $RayWave
@onready var timer_wave_bullets: Timer = $TimerWaveBullets
var bullet  = load("res://Scenes/boss_bullet.tscn")
var instance
var wave_bullet_amount = 1
var wave_bullet_position = 0.0
var job_apl_resource_array = ["res://Recource/cortisol.tres", "res://Recource/copilot.tres", "res://Recource/excel.tres"]

#POP_UP WINDOW
@onready var timer_pop_up_window: Timer = $TimerPopUpWindow
var pop_up_window = load("res://Scenes/job_aplication_pop_up_window.tscn")
var last_pressed_key = ""
var current_pressed_key = ""
var pop_up_instance = null
var prev_pop_up_instance = null
var rng = RandomNumberGenerator.new()
var quota = 20

#GRASS
@onready var timer_grass: Timer = $TimerGrass
var grass = load("res://Scenes/grass.tscn")
var grass_instance = null
var prev_grass_instance = null
var grass_amount = 0

#CAT AND DOG
@export var cat_do_recource: CatDogResource
@onready var timer_cat_and_dog: Timer = $TimerCatAndDog
var cat_dog_scene = load("res://Scenes/cat_dog_follow.tscn")
@onready var cat_dog_instance = null
var cat_dog_resource_array = ["res://Recource/cat.tres", "res://Recource/dog.tres"]

#PALKA PION
@onready var timer_palka_pion: Timer = $TimerPalkaPion
var palka_pion_scene = load("res://Scenes/palka_pion.tscn")
var palka_pion_amount = 1
var palka_pion_instance = null

#PALKA POZIOM
@onready var timer_palka_poziom: Timer = $TimerPalkaPoziom
var palka_poziom_instance = null
var palka_poziom_scene = load("res://Scenes/palka_poziom.tscn")

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
@onready var timer_roblox_balls: Timer = $TimerRobloxBalls
var roblox_balls_scene = load("res://Scenes/roblox_balls.tscn")
var roblox_balls_instance = null
var roblox_balls_amount = 1

#GRAVITY PULL
@onready var timer_gravity_pull: Timer = $TimerGravityPull
var gravity_pull_scene = load("res://Scenes/gravity_pull.tscn")
var gravity_pull_instance = null

#BOBER BULLETS
@onready var timer_bober_bullets: Timer = $TimerBoberBullets
var bober_bullet_scene = load("res://Scenes/bober_bullets.tscn")
var bober_bullet_instance = null
@onready var ray_bober_bullet: RayCast3D = $RayBoberBullet







#FALA
func _on_timer_wave_bullets_timeout() -> void:
	while wave_bullet_amount <= 60:
		instance = bullet.instantiate()
		
		var rand_resource = rng.randf_range(0, 3)
		var current_resource = load(job_apl_resource_array[rand_resource])
		instance.set_meta("job_apl_recource", current_resource)
		instance.get_node("StaticBody3D/Sprite3D").texture = current_resource.texture
		instance.get_node("StaticBody3D/Sprite3D").scale = Vector3(0.1, 0.1, 0.1)
		
		instance.position = ray_wave.global_position
		instance.position.x -= wave_bullet_position
		wave_bullet_position += 1
		wave_bullet_amount += 1
		
		get_parent().add_child(instance)
	wave_bullet_amount = 1
	wave_bullet_position = 0.0
	
	var rand_time = rng.randf_range(1.0, 3.0)
	timer_wave_bullets.wait_time = rand_time



#POP_UP WINDOW
func _on_timer_pop_up_window_timeout() -> void:
	pop_up_instance = pop_up_window.instantiate()
	get_parent().add_child(pop_up_instance)
	if prev_pop_up_instance:
		prev_pop_up_instance.queue_free()
	prev_pop_up_instance = pop_up_instance
	quota = 20



func _input(event: InputEvent) -> void:
	if pop_up_instance != null:
		if event.is_pressed() and not event is InputEventMouseMotion:
			if event is InputEventKey and event.pressed and not event.is_echo():
				current_pressed_key = OS.get_keycode_string(event.keycode)
			
			
			if current_pressed_key != last_pressed_key:
				var progress_bar = pop_up_instance.get_node("Control/ProgressBar")
			
				if progress_bar:
					pop_up_instance.get_node("Control").pop_up_quota()
					progress_bar.value += 1
					quota -= 1
					if progress_bar.value >= progress_bar.max_value:
						pop_up_instance.queue_free()
						pop_up_instance = null
	
	last_pressed_key = current_pressed_key



#GRASS
func _on_timer_grass_timeout() -> void:
	#while grass_amount < 2:
	grass_instance = grass.instantiate()
	var rand_position_x = rng.randf_range(25.0, -25.0)
	var rand_position_z = rng.randf_range(20.0, -30.0)
	grass_instance.position = Vector3(rand_position_x, -10.524, rand_position_z)
	get_parent().add_child(grass_instance)
	
	var transitionTween = create_tween()
	transitionTween.tween_property(grass_instance, "position:y", -3.965, 0.3)
	
	boss.texture = load("res://Assets/Characters/Bosses/maklowicz_attack.png")
	await get_tree().create_timer(0.2).timeout
	boss.texture = load("res://Assets/Characters/Bosses/maklowicz_idle.png")
	
	await get_tree().create_timer(3.0).timeout
	grass_instance.get_node("GrassDisappear").play()
	transitionTween.tween_property(grass_instance, "position:y", -10.524, 0.3)



#CAT AND DOG FOLLOW
func _on_timer_cat_and_dog_timeout() -> void:
	cat_dog_instance = cat_dog_scene.instantiate()
	
	var rand_resource = rng.randf_range(0, 2)
	var current_resource = load(cat_dog_resource_array[rand_resource])
	cat_dog_instance.set_meta("cat_dog_recsource", current_resource)
	cat_dog_instance.get_node("Sprite3D").texture = current_resource.texture
	
	cat_dog_instance.position = Vector3(0, 0, 15.822)
	
	get_parent().add_child(cat_dog_instance)
	
	boss.texture = load("res://Assets/Characters/Bosses/maklowicz_attack.png")
	await get_tree().create_timer(0.2).timeout
	boss.texture = load("res://Assets/Characters/Bosses/maklowicz_idle.png")



#PALKA PION
func _on_timer_palka_pion_timeout() -> void:
	boss.texture = null
	while palka_pion_amount <= 10:
		palka_pion_instance = palka_pion_scene.instantiate()
		var rand_position_x = rng.randf_range(15.0, -15.0)
		palka_pion_instance.position = Vector3(rand_position_x, -0.182, 15.94)
		get_parent().add_child(palka_pion_instance)
		
		var x_degrees = -90
		var rotation_x = deg_to_rad(x_degrees)
		var tween = create_tween()
		tween.tween_property(palka_pion_instance, "rotation:x", rotation_x, 0.5).set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
		
		await get_tree().create_timer(0.1).timeout
		#todo DŹWIĘK
		await get_tree().create_timer(0.5).timeout
		
		
		palka_pion_instance.queue_free()
		palka_pion_amount += 1
		#await get_tree().create_timer(0.8).timeout
	palka_pion_amount = 1



#PALKA POZIOM
func _on_timer_palka_poziom_timeout() -> void:
	boss.texture = null
	palka_poziom_instance = palka_poziom_scene.instantiate()
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
	



#CHOCOLATE

func _on_timer_chocolate_timeout() -> void:
	boss.texture = load("res://Assets/Characters/Bosses/labubu_attack.png")
	
	var chocolate_instance = chocolate_scene.instantiate()
	get_tree().current_scene.add_child(chocolate_instance)
	chocolate_instance.global_position = global_position + Vector3(0, 12.901, 0)
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
	matcha_instance.global_position = global_position + Vector3(0, 12.901, 0)
	
	var rand_pos_x = rng.randf_range(25.0, -20.0)
	var pos_y = -0.141
	var rand_pos_z = rng.randf_range(15.0, -20.0)
	
	var tween = create_tween()
	tween.tween_property(matcha_instance, "position", Vector3(rand_pos_x, pos_y, rand_pos_z), 0.7)



#ROBLOX BULLET
func _on_timer_roblox_bullet_timeout() -> void:
	roblox_bullet_instance = roblox_bullet_scene.instantiate()
	var rand_pos_x = rng.randf_range(25.0, -25.0)
	roblox_bullet_instance.position = ray_roblox_bullet.global_position
	roblox_bullet_instance.position.x = rand_pos_x
	
	get_parent().add_child(roblox_bullet_instance)



#ROBLOX BALLS
func _on_timer_roblox_balls_timeout() -> void:
	boss_anim_sprites.play("roblox_baller")
	while roblox_balls_amount <= 40:
		roblox_balls_instance = roblox_balls_scene.instantiate()
		var pos_y = 26.0
		var rand_pos_x = rng.randf_range(25.0, -25.0)
		var rand_pos_z = rng.randf_range(20.0, -30.0)
		roblox_balls_instance.position = Vector3(rand_pos_x, pos_y, rand_pos_z)
		roblox_balls_amount += 1
		get_parent().add_child(roblox_balls_instance)
	roblox_balls_amount = 1
	
	await get_tree().create_timer(2).timeout
	boss_anim_sprites.play("roblox_robux")



#GRAVITY PULL
func _on_timer_gravity_pull_timeout() -> void:
	boss_anim_sprites.play("bober_attack")
	
	gravity_pull_instance = gravity_pull_scene.instantiate()
	gravity_pull_instance.global_position = global_position
	get_parent().add_child(gravity_pull_instance)
	
	await get_tree().create_timer(12).timeout
	gravity_pull_instance.queue_free()
	boss_anim_sprites.play("bober_idle")



#BOBER BULLETS
func _on_timer_bober_bullets_timeout() -> void:
	bober_bullet_instance = bober_bullet_scene.instantiate()
	var rand_pos_x = rng.randf_range(25.0, -25.0)
	bober_bullet_instance.position = ray_bober_bullet.global_position
	bober_bullet_instance.position.x = rand_pos_x
	
	get_parent().add_child(bober_bullet_instance)
