extends Node3D

const SPEED = 40.0
var velocity: Vector3 = Vector3.ZERO

func set_target_position(target_pos: Vector3):
	var direction = (target_pos - global_position).normalized()
	velocity = direction * SPEED
	#look_at(target_pos, Vector3.UP)

func _process(delta: float) -> void:
	global_position += velocity * delta

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	queue_free()
