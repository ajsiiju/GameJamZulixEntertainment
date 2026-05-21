extends CharacterBody3D

var cat_dog_speed = 11.5
var health = 20
@onready var player = get_parent().get_node("player")
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	if health == 0:
		queue_free()

func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * cat_dog_speed
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player":
		queue_free()
