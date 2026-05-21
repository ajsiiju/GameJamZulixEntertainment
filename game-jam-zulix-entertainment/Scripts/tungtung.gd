extends CharacterBody3D

@export var speed: float = 3.0
var player: CharacterBody3D = null

func _ready():
	# Znajdź gracza (zakładając, że jest w grupie "player")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta: float) -> void:
	if not player:
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	
	look_at(player.global_position, Vector3.UP)
	
	move_and_slide()
