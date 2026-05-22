extends Area3D

@onready var widzisz_mnie_audio = $widzisz_mnie_audio
@onready var brek_img = get_tree().get_first_node_in_group("ui").get_node("brek_img")

func _ready():
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		widzisz_mnie_audio.play()
		brek_img.visible = true
		get_tree().create_timer(0.1).timeout.connect(
		func():
				brek_img.visible = false,
			CONNECT_ONE_SHOT
		)
