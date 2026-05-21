extends TextureRect

var social_points: int = 0
var timer_to_show_shop: float = 5.0
var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.set_social_points_ui.connect(set_social_points_ui)
	var shop_ui = get_tree().get_first_node_in_group("shop_ui")
	shop_ui.move_social_points.connect(move_social_points)
	move_social_points("corner")

func _process(_delta: float) -> void:
	$social_points_label.text = str(player.social_points)
	
func set_social_points_ui(points):
	social_points = points

func move_social_points(move_position):
	match move_position:
		"middle":
			anchor_left = 0.5
			anchor_right = 0.5
			anchor_top = 0.0
			anchor_bottom = 0.0
			offset_left = -169
			offset_right = 175
			offset_top = 43
			offset_bottom = 273
		"corner":
			anchor_left = 0.97
			anchor_right = 0.97
			anchor_top = 0.15
			anchor_bottom = 0.15
			offset_left = -344
			offset_right = 0
			offset_top = -115
			offset_bottom = 115
