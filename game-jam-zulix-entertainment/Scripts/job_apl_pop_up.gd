extends Control

var rng = RandomNumberGenerator.new()
var instance_scene = load("res://Scenes/pop_up.tscn")
@onready var control: Control = $Control
var instance

func _ready() -> void:
	var rand_x = rng.randf_range(50, 1430)
	var rand_y = rng.randf_range(50, 590.0)
	
	instance = instance_scene.instantiate()
	
	instance.offset = Vector2(rand_x, rand_y)
	
	get_parent().add_child(instance)
