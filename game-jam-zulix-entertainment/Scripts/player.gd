extends CharacterBody3D

#TESTTEST
var active_gravity_well: Area3D = null
#TESTTEST

@onready var camera_rig: SpringArm3D = $CameraRig
@onready var camera: Camera3D = $CameraRig/Camera3D
@onready var anim_player: AnimationPlayer = $Mesh/AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var raycast: RayCast3D = $CameraRig/Camera3D/RayCast3D
@onready var test_enemy: CharacterBody3D = $"../test_enemy"
@onready var timer: Timer = $CameraRig/Camera3D/RayCast3D/Timer
@onready var audio_player = $footsteps
#@onready var anim_player: AnimationPlayer = $Mesh/AnimationPlayer

@export var SPECIAL_ATTACK4_DAMAGE: float = -100.0
@export var SPECIAL_ATTACK3_HEAL: float = 50.0
@export var SPECIAL_ATTACK4_HEAL: float = 50.0

const DEFAULT_SPEED: float = 12.0
var speed = DEFAULT_SPEED
const CROUCH_SPEED: float = 4.0
const JUMP_VELOCITY := 6

var visible_health: float = 1000.0
var target_health: float = 1000.0
const MAX_HEALTH: float = 1000.0
const HEALTH_REGEN_PER_FRAME: float = 0.04
const SPECIAL_ATTACK_IMMUNITY_TIME: float = 4.0
var immunity = false
var social_points: int  = 100
# skill number 0 is nothing
var unlocked_skills: Array[bool] = [true]
var skill_unlock_costs: Array[int] = [0,5,5,5,5]
var skill_costs: Array[int] = [0,0,0,0,0]
var dashing = false
var DASH_SPEED: float = 40.0
var dash_velocity: Vector3

signal hotbar_icon_unlocked(number: int)
signal hotbar_key_pressed(number: int)
signal set_social_points_ui(points: int)
var points = Callable(self, "change_social_points")

func _ready() -> void:
	var shop_ui = get_tree().get_first_node_in_group("shop_ui")
	shop_ui.unlock_skill.connect(unlock_skill)
	unlocked_skills.resize(5)

func _process(_delta: float) -> void:
	visible_health = lerp(visible_health, target_health, HEALTH_REGEN_PER_FRAME)

func _physics_process(delta: float) -> void:
	#TESTTEST
	# 1. CALCULATE CUSTOM HORIZONTAL PULL ONLY
	var horizontal_pull := Vector3.ZERO
	
	if active_gravity_well:
		var raw_direction = active_gravity_well.global_position - global_position
		raw_direction.y = 0 # Ensure no Y manipulation
		
		var pull_direction = raw_direction.normalized()
		
		# Keep your custom multiplier for punchy horizontal dragging
		var gravity_multiplier: float = 20
		var gravity_power = active_gravity_well.gravity * gravity_multiplier
		
		horizontal_pull = pull_direction * gravity_power * delta

	# ALWAYS APPLY NORMAL DOWNWARD GRAVITY ON Y AXIS
	# This ensures you land properly and prevents jump-stacking glitches!
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif velocity.length() > 0.1:
		if not audio_player.playing:
			audio_player.play()
		else:
			audio_player.stream_paused = false
	else:
		audio_player.stream_paused = true
		
	# #TESTTEST

	# 2. HANDLE JUMP (Will now behave exactly like standard game mechanics)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# 3. CALCULATE INTENTIONAL PLAYER MOVEMENT (WASD)
	if Input.mouse_mode != Input.MOUSE_MODE_CONFINED:
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction := (camera_rig.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() * input_dir.length()
		
		dash_velocity = dash_velocity.move_toward(Vector3.ZERO, DASH_SPEED * delta * 2)

		if direction:
			velocity.x = direction.x * speed + dash_velocity.x
			velocity.z = direction.z * speed + dash_velocity.z
			
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

	# 4. COMBINE ONLY THE HORIZONTAL PULL 
	# (We already added the vertical project gravity safely up on line 18)
	velocity += horizontal_pull

	# 5. EXECUTE MOVEMENT
	move_and_slide()
	#TESTTEST
	
	
	#PREVIOUS
	 #Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	#
	#if Input.mouse_mode != Input.MOUSE_MODE_CONFINED:
		#var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		#var direction := (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y))
		#direction = Vector3(direction.x, 0, direction.z).normalized() * input_dir.length()
	#
		#
		#if direction:
			#velocity.x = direction.x * speed
			#velocity.z = direction.z * speed
		#else:
			#velocity.x = move_toward(velocity.x, 0, speed)
			#velocity.z = move_toward(velocity.z, 0, speed)
		#
		#move_and_slide()
	
	
	#MOVEMENT ANIMATION
	var current_speed := velocity.length()
	if current_speed > 1:
		#anim_player.play("base/run")
		anim_tree.set("parameters/movement/transition_request", "run")
	else:
		#anim_player.play("base/idle")
		anim_tree.set("parameters/movement/transition_request", "idle")
	if Input.mouse_mode == Input.MOUSE_MODE_CONFINED:
		anim_tree.set("parameters/movement/transition_request", "idle")
	
	# rotate player model with camera
	rotation.y = lerp_angle(rotation.y, camera_rig.rotation.y, 0.3)

func _input(event: InputEvent) -> void:
	# handle crouching
	if Input.is_action_just_pressed("crouch"):
		speed = CROUCH_SPEED
		anim_tree.set("parameters/movement/transition_request", "crouch")
	elif Input.is_action_just_released("crouch"):
		speed = DEFAULT_SPEED
	
	for skill_number in range(0, 5):
		var action_name = "key_" + str(skill_number)
		if event.is_action(action_name) \
		and event.is_pressed() \
		and unlocked_skills[skill_number] \
		and (skill_costs[skill_number] <= social_points):
			hotbar_key_pressed.emit(skill_number)
			activate_skill(skill_number)

func turn_to(direction: Vector3) -> void:
	if  direction:
		var yaw:= atan2(-direction.x, -direction.z)
		yaw = lerp_angle(rotation.y, yaw, 0.15)
		rotation.y = yaw
	
func unlock_skill(skill_number):
	DebugChat.message("unlocking skill: " + str(skill_number))
	if (skill_unlock_costs[skill_number] <= social_points) \
	and (unlocked_skills[skill_number] == false):
		social_points -= skill_unlock_costs[skill_number]
		set_social_points_ui.emit(social_points)
		unlocked_skills[skill_number] = true
		var shop_ui = get_tree().get_first_node_in_group("shop_ui")
		shop_ui.get_node("shop_bg/skill_offer" + str(skill_number) + "/buy_button1").disabled = true
		hotbar_icon_unlocked.emit(skill_number)
		
func change_social_points(points: int):
	social_points += points
	set_social_points_ui.emit(social_points)

func activate_skill(skill_number):
	match skill_number:
		1:
			pass
		2:
			if !dashing:
				dashing = true
				dash_velocity = -global_basis.z * DASH_SPEED
				immunity = true
				get_tree().create_timer(0.1).timeout.connect(
					func():
						dashing = false
						immunity = false,
						CONNECT_ONE_SHOT
				)
			return
		3:
			change_health(SPECIAL_ATTACK3_HEAL)
		4: 
			change_health(SPECIAL_ATTACK4_HEAL)
			immunity = true
			get_tree().create_timer(SPECIAL_ATTACK_IMMUNITY_TIME).timeout.connect(
				func():
					immunity = false,
					CONNECT_ONE_SHOT
			)
			var boss = get_tree().get_first_node_in_group("boss")
			boss.change_health(SPECIAL_ATTACK4_DAMAGE)
		_:
			pass
	change_social_points(-skill_costs[skill_number])

func change_health(health_difference):
	if immunity and health_difference < 0:
		return
	target_health += health_difference
	target_health = clamp(target_health, 0.0, MAX_HEALTH)
	if target_health <= 0.0:
		get_tree().change_scene_to_file("res://Scenes/game_lost.tscn")

func player_immunity(is_immune):
	if is_immune:
		immunity = true
	DebugChat.message("player immune: " + str(is_immune))
	
