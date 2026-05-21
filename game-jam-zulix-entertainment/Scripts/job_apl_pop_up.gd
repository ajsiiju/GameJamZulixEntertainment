extends Control

var rng = RandomNumberGenerator.new()
var instance_scene = load("res://Scenes/pop_up.tscn")
var instance
var instance_amount = 0
var spawned_popups: Array = []
var label = null
var quota = 20

func _ready() -> void:
	while instance_amount < 10:
		var rand_x = rng.randf_range(50, 1430)
		var rand_y = rng.randf_range(50, 590.0)
	
		instance = instance_scene.instantiate()
	
		instance.position = Vector2(rand_x, rand_y)
	
		add_child(instance)
		spawned_popups.append(instance)
		instance_amount += 1
	
	instance_amount = 0

func pop_up_quota() -> void:
	for popup in spawned_popups:
		label = popup.get_node("Label")
		if label:
			label.text = str(quota)
	quota -= 1
