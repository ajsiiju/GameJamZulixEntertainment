extends MeshInstance3D

@onready var platform = self
var john_pork_scene = preload("res://Scenes/john_pork.tscn")
var platform_range: Array[float]
var timer: float = 0.0
var SPAWN_COOLDOWN: float = 20.0
enum Borders {
	MIN_X,
	MAX_X,
	MIN_Y,
	MAX_Y,
	MIN_Z,
	MAX_Z
}

func _ready() -> void:
	platform_range = update_platform_range(platform)


func _process(delta: float) -> void:
	timer += delta
	if timer >= SPAWN_COOLDOWN:
		john_pork_spawn()
		timer = 0.0

func john_pork_spawn():
	var john_pork_instance = john_pork_scene.instantiate()
	john_pork_instance.position = Vector3(
		randf_range(platform_range[Borders.MIN_X],
					platform_range[Borders.MAX_X]),
		randf_range(platform_range[Borders.MIN_Y],
					platform_range[Borders.MAX_Y]),
		randf_range(platform_range[Borders.MIN_Z],
					platform_range[Borders.MAX_Z])
		)
	get_parent().add_child(john_pork_instance)
	
func update_platform_range(updated_platform: MeshInstance3D) -> Array[float]:
	var middle = updated_platform.global_position
	var half = updated_platform.mesh.size / 2
	var min_x = middle.x - half.x
	var max_x = middle.x + half.x
	var min_y = middle.y - half.y
	var max_y = middle.y + half.y
	var min_z = middle.z - half.z
	var max_z = middle.z + half.z
	return [min_x, max_x, min_y, max_y, min_z, max_z]
