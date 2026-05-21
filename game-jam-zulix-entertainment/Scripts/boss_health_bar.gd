extends ProgressBar


var boss

func _ready() -> void:
	boss = get_tree().get_first_node_in_group("boss")

func _process(_delta: float) -> void:
	value = boss.visible_health
