extends TextureRect

var social_points: int = 0

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.change_social_points.connect(change_social_points)


func _process(_delta: float) -> void:
	$social_points_label.text = str(social_points)
	
func change_social_points(points):
	social_points += points
