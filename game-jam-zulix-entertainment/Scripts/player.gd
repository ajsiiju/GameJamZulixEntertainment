extends CharacterBody3D

@onready var camera_rig: SpringArm3D = $CameraRig
@onready var camera: Node3D = $CameraRig/Camera3D
@onready var anim_player: AnimationPlayer = $Mesh/AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var raycast: RayCast3D = $CameraRig/Camera3D/RayCast3D	# raycast is currently unused
@onready var test_enemy: CharacterBody3D = $"../test_enemy"
@onready var timer: Timer = $CameraRig/Camera3D/RayCast3D/Timer

var health_points = 10
var speed := 4.0
const JUMP_VELOCITY = 4.5

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_test"):
		health_points -= 1
	if (health_points < 1):
		queue_free()

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
		speed = 2.0
		anim_tree.set("parameters/movement/transition_request", "crouch")
	elif Input.is_action_just_released("crouch"):
		speed = 4.0
