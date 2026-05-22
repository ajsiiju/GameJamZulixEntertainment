extends RayCast3D

<<<<<<< Updated upstream
var speed: float = 70.0
=======
var speed: float = 75.0
@export var PLAYER_PROJECTILE_DAMAGE: float = -10.0
@onready var area = $Area3D
@onready var mesh: Node3D = $Mesh

func _ready() -> void:
	mesh.rotation = Vector3(randf()*3, randf()*3, randf()*3)
>>>>>>> Stashed changes

func _physics_process(delta: float) -> void:
	position += global_basis * Vector3.FORWARD * speed * delta
	target_position = Vector3.FORWARD * speed * delta
	mesh.rotation.x += 0.3
	force_raycast_update()
	var collider = get_collider()
	if (collider != null):
		collider.damage.call(10)
		queue_free()

func cleanup() -> void:
	queue_free()
