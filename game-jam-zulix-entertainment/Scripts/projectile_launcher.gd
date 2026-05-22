extends Node3D

const PROJECTILE = preload("uid://fjehkmtigldw")
@onready var timer: Timer = $Timer
@onready var camera: SpringArm3D = $"../CameraRig"
@onready var raycast: RayCast3D = $"../CameraRig/Camera3D/RayCast3D"
@onready var animation: Node3D = $"../MC_NLA_ANIMATIONS_OK"
@onready var ability_timer: Timer = $"../AbilityTimer"


func _physics_process(delta: float) -> void:
	if timer.is_stopped():
		if ability_timer.is_stopped() and Input.is_action_pressed("shoot"):
			animation.play_shoot.call()
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
			$"../klapek_sound".play()
			projectile.global_transform = global_transform
