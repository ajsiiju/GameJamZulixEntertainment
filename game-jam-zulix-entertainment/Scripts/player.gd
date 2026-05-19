extends CharacterBody3D

var speed := 4.0
var active_skill: int = 1
const JUMP_VELOCITY = 4.5
@onready var camera: Node3D = $CameraRig/Camera3D
@onready var anim_player: AnimationPlayer = $Mesh/AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
signal hotbar_key_pressed(number)

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
		turn_to(direction)
	
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

func turn_to(direction: Vector3) -> void:
	if  direction:
		var yaw:= atan2(-direction.x, -direction.z)
		yaw = lerp_angle(rotation.y, yaw, 0.15)
		rotation.y = yaw

func _input(event):
	for number in range(1, 10):
		var action_name = "key_" + str(number)
		if event.is_action(action_name) and event.is_pressed():
			hotbar_key_pressed.emit(number)
			active_skill = number
		
	
	
