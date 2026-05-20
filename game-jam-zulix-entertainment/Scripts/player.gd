extends CharacterBody3D

var speed := 4.0
var active_skill: int = 0
var social_points: int  = 0
# skill number 0 is nothing
var unlocked_skills: Array[bool] = [true]
var skill_costs: Array[int] = [0,5,5,5,5]
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
	for number in range(0, 5):
		var action_name = "key_" + str(number)
		if event.is_action(action_name) \
		and event.is_pressed() \
		and unlocked_skills[number]:
			hotbar_key_pressed.emit(number)
			active_skill = number
	
	if event.is_action("ui_accept") and event.is_pressed(): # debug
		social_points += 1
		set_social_points_ui.emit(social_points)
	
func unlock_skill(skill_number):
	DebugChat.message("unlocking skill: " + str(skill_number))
	if (skill_costs[skill_number] <= social_points) \
	and (unlocked_skills[skill_number] == false):
		social_points -= skill_costs[skill_number]
		set_social_points_ui.emit(social_points)
		unlocked_skills[skill_number] = true
		
func change_social_points(points):
	social_points += points
	set_social_points_ui.emit(social_points)
	
