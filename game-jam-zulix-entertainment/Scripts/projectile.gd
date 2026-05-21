extends RayCast3D

var speed: float = 75.0
@export var PLAYER_PROJECTILE_DAMAGE: float = -10.0
@onready var area = $Area3D

func _physics_process(delta: float) -> void:
	position += global_basis * Vector3.FORWARD * speed * delta
	target_position = Vector3.FORWARD * speed * delta
	force_raycast_update()
	var collider = get_collider()
	if (collider != null):
		var body = collider.get_parent()
		if body.has_method("change_health"):
			body.change_health(PLAYER_PROJECTILE_DAMAGE)
		elif body.get_node("Area3D").has_method("projectile_hit"):
			body.get_node("Area3D").projectile_hit()
		queue_free()

func cleanup() -> void:
	queue_free()
	
