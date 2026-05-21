extends Node3D

@onready var sprite: Sprite3D = $StaticBody3D/Sprite3D
@onready var particles: GPUParticles3D = $StaticBody3D/GPUParticles3D
@onready var collision_damage: CollisionShape3D = $StaticBody3D/Area3D2/CollisionShape3D



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("ground"):
		await get_tree().create_timer(0.2).timeout
		$StaticBody3D/Area3D2/CollisionShape3D.shape.radius = 0.6
		sprite.visible = false
		collision_damage.disabled = false
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
