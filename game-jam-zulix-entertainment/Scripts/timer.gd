extends ProgressBar

@onready var progress_bar = $"."
var active_tween := create_tween()


func _on_timer_timeout() -> void:
	if progress_bar.value >= 60:
		progress_bar.value = 0
	else:
		active_tween = create_tween()
		active_tween.tween_property(progress_bar, "value", progress_bar.value + 1, 1.0).set_trans(Tween.TRANS_LINEAR)
