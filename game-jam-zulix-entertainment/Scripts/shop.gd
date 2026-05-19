extends Area3D

var open_shop_timer: float = 5.0
signal player_immunity(is_immune: bool)
@export var SHOP_VISIBILITY_TIME: float  = 15.0

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	open_shop_timer -= delta
	if open_shop_timer <= -SHOP_VISIBILITY_TIME:
		player_immunity.emit(false)
		queue_free()
	elif open_shop_timer <= 0:
		$Label3D.text = ""
	else:
		$Label3D.text = "SHOP OPEN IN\n" + "%0.2f" % open_shop_timer

func _on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		player_immunity.emit(true)

func _on_body_exited(body: Node3D):
	if body.is_in_group("player"):
		player_immunity.emit(false)
