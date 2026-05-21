extends Node3D

const PROJECTILE = preload("uid://fjehkmtigldw")
@onready var timer: Timer = $Timer
@onready var camera: SpringArm3D = $"../CameraRig"
@onready var raycast: RayCast3D = $"../CameraRig/Camera3D/RayCast3D"

func _physics_process(delta: float) -> void:
	if timer.is_stopped():
		if Input.is_action_pressed("shoot"):
			if (raycast.get_collider() == null):
				rotation.x = camera.rotation.x + 0.05
			else:
				# if enemy targetted, projectiles fire at the position the camera is pointing to
				var target_point := raycast.get_collision_point()
				var a = target_point.y - global_position.y
				var b = global_position.distance_to(target_point)
				var angle = asin(a/b)
				rotation.x = angle
				
			timer.start(0.2)
			var projectile = PROJECTILE.instantiate()
			add_child(projectile)
			projectile.global_transform = global_transform
