extends ProgressBar


var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	value = player.visible_health
