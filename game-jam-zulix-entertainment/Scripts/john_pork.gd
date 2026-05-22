extends Area3D

const SPEED: float = 5.0
const ROTATION_SPEED: float = 5.0
const TIME_TO_FLY_UP: float = 20.0
var timer: float = 0.0
@onready var pork_head = $pork_head

func _ready():
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	if timer > TIME_TO_FLY_UP:
		position.y += SPEED * delta
	else:
		position.x += SPEED * delta
		position.z -= SPEED * delta
	timer += delta
	
	pork_head.rotation.x += ROTATION_SPEED * delta
	
func _on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		body.reparent(self)
		body.set_physics_process(false)
