extends Node3D

const SPEED = 20.0
@onready var bullet_mesh: CSGSphere3D = $StaticBody3D/bullet_mesh
@onready var ray: RayCast3D = $RayCast3D
var damage = 5
signal get_damage(damage)


func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	#ray.enabled = false
	if ray.is_colliding():
		if ray.get_collider().is_in_group("player"):
			emit_signal("get_damage", damage)
			queue_free()
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
