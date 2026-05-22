extends Node3D


func _on_timer_sound_timeout() -> void:
	$pala_pion_sound.play()



func _on_timer_delete_timeout() -> void:
	queue_free()
