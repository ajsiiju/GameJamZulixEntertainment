extends CharacterBody3D

@onready var camera_rig: SpringArm3D = $CameraRig
@onready var camera: Camera3D = $CameraRig/Camera3D
@onready var anim_player: AnimationPlayer = $Mesh/AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var raycast: RayCast3D = $CameraRig/Camera3D/RayCast3D	# raycast is currently unused
@onready var test_enemy: CharacterBody3D = $"../test_enemy"
@onready var timer: Timer = $CameraRig/Camera3D/RayCast3D/Timer

var target_health:float = 10
var speed := 8.0
const DEFAULT_SPEED:float = 8.0
const CROUCH_SPEED:float = 4.0
const JUMP_VELOCITY := 4.5

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_test"):
		target_health -= 1
	if (target_health < 1):
		queue_free()
const DEFAULT_SPEED: float = 4.0
var speed = DEFAULT_SPEED
var visible_health: float = 50.0
var target_health: float = 50.0
const MAX_HEALTH: float = 100.0
const HEALTH_REGEN_PER_FRAME: float = 0.02
const SPECIAL_ATTACK_IMMUNITY_TIME: float = 4.0
var immunity = false
var social_points: int  = 0
# skill number 0 is nothing
var unlocked_skills: Array[bool] = [true]
var skill_unlock_costs: Array[int] = [0,5,5,5,5]
var skill_costs: Array[int] = [0,7,7,7,7]
const JUMP_VELOCITY = 4.5
@onready var camera: Node3D = $CameraRig/Camera3D
#@onready var anim_player: AnimationPlayer = $Mesh/AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
signal hotbar_key_pressed(number: int)
signal set_social_points_ui(points: int)


func _ready() -> void:
	var shop_ui = get_tree().get_first_node_in_group("shop_ui")
	shop_ui.unlock_skill.connect(unlock_skill)
	unlocked_skills.resize(5)

func _physics_process(delta: float) -> void:
	 #Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.mouse_mode != Input.MOUSE_MODE_CONFINED:
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction := (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y))
		direction = Vector3(direction.x, 0, direction.z).normalized() * input_dir.length()
		
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

		move_and_slide()
	
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
func _process(_delta):
	visible_health = lerp(visible_health, target_health, HEALTH_REGEN_PER_FRAME)

func turn_to(direction: Vector3) -> void:
	if  direction:
		var yaw:= atan2(-direction.x, -direction.z)
		yaw = lerp_angle(rotation.y, yaw, 0.15)
		rotation.y = yaw

func _input(event):
	for skill_number in range(0, 5):
		var action_name = "key_" + str(skill_number)
		if event.is_action(action_name) \
		and event.is_pressed() \
		and unlocked_skills[skill_number] \
		and (skill_costs[skill_number] <= social_points):
			hotbar_key_pressed.emit(skill_number)
			activate_skill(skill_number)
	
	if event.is_action("ui_accept") and event.is_pressed(): # debug
		social_points += 1
		set_social_points_ui.emit(social_points)
	
func unlock_skill(skill_number):
	DebugChat.message("unlocking skill: " + str(skill_number))
	if (skill_unlock_costs[skill_number] <= social_points) \
	and (unlocked_skills[skill_number] == false):
		social_points -= skill_unlock_costs[skill_number]
		set_social_points_ui.emit(social_points)
		unlocked_skills[skill_number] = true
		
func change_social_points(points: int):
	social_points += points
	set_social_points_ui.emit(social_points)
		
func activate_skill(skill_number):
	change_social_points(-skill_costs[skill_number])
	match skill_number:
		1:
			pass
		2:
			speed = 80.0
			immunity = true
			get_tree().create_timer(0.1).timeout.connect(
				func():
					speed = DEFAULT_SPEED
					immunity = false,
					CONNECT_ONE_SHOT
			)
		3:
			change_health(20)
		4: 
			change_health(40)
			immunity = true
			get_tree().create_timer(SPECIAL_ATTACK_IMMUNITY_TIME).timeout.connect(
				func():
					immunity = false,
					CONNECT_ONE_SHOT
			)
		_:
			pass

func change_health(health_difference):
	if immunity and health_difference < 0:
		return
	target_health += health_difference
	target_health = clamp(target_health, 0.0, MAX_HEALTH)

func player_immunity(is_immune):
	if is_immune:
		immunity = true
	DebugChat.message("player immune: " + str(is_immune))
