extends Node3D

const SPEED = 35.0

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		queue_free()
