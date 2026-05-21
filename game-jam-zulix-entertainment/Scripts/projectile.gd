extends RayCast3D

var speed: float = 70.0

func _physics_process(delta: float) -> void:
	position += global_basis * Vector3.FORWARD * speed * delta
	target_position = Vector3.FORWARD * speed * delta
	force_raycast_update()
	var collider = get_collider()
	if (collider != null):
		collider.damage.call(10)
		queue_free()

func cleanup() -> void:
	queue_free()
