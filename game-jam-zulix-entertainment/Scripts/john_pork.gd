extends Area3D

const SPEED: float = 5.0

func _ready():
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	position.x += SPEED * delta
	
func _on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		body.reparent(self)
