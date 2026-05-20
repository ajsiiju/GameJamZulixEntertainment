extends TextureRect

var social_points: int = 0

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.set_social_points_ui.connect(set_social_points_ui)


func _process(_delta: float) -> void:
	$social_points_label.text = str(social_points)
	
func set_social_points_ui(points):
	social_points = points
