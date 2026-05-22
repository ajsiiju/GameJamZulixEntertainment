extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start_cutscene.tscn")

func _on_authors_pressed() -> void:
	$main_menu_buttons.visible = false
	$AuthorsScreen.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_texture_button_pressed() -> void:
	$main_menu_buttons.visible = true
	$AuthorsScreen.visible = false
