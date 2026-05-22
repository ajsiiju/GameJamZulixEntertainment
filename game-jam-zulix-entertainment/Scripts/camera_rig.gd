extends SpringArm3D

@onready var camera:Camera3D = $Camera3D
@onready var turn_rate:= 200
@onready var mouse_sensitivity:= 0.05
var mouse_input : Vector2 = Vector2()
@onready var player: Node3D = get_parent()
@onready var camera_offset: Node3D = $"../CameraOffset"
var camera_rig_height:float = position.y
var debug_value:float = 0
var is_broken_camera: bool = false

func _ready() -> void:
	spring_length = 2.75
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CONFINED:
		var look_input:= Input.get_vector("view_right", "view_left", "view_down", "view_up")
		if is_broken_camera:
			rotation_degrees.y += 800.0 * delta
			rotation_degrees.x += 400.0 * delta
		else:
			look_input = turn_rate * look_input * delta
			look_input += mouse_input
			mouse_input = Vector2()
		rotation_degrees.x += look_input.y
		player.rotation_degrees.y += look_input.x
		rotation_degrees.x = clampf(rotation_degrees.x, -50, 35)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_input = -event.relative * mouse_sensitivity
	elif event is InputEventKey and event.keycode == KEY_ESCAPE and event.is_pressed():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(_delta: float) -> void:
	global_position = camera_offset.global_position + Vector3(0, camera_rig_height, 0)
	
