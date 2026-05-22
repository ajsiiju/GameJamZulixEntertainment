extends CanvasLayer

@onready var cutscene = $VideoStreamPlayer
@onready var decision_screen = $DecisionScreen

func _ready():
	decision_screen.visible = false
	cutscene.finished.connect(_on_video_finished)
	cutscene.play()

func _on_video_finished():
	cutscene.visible = false
	decision_screen.visible = true
	

func _process(_delta):
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
