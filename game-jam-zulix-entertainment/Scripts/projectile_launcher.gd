extends Node3D

const PROJECTILE = preload("uid://fjehkmtigldw")
@onready var timer: Timer = $Timer

func _physics_process(delta: float) -> void:
	if timer.is_stopped():
		if Input.is_action_pressed("shoot"):
			timer.start(0.2)
			var projectile = PROJECTILE.instantiate()
			add_child(projectile)
			projectile.global_transform = global_transform
