extends HBoxContainer

@onready var last_active_panel: Panel = $Panel1

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.hotbar_key_pressed.connect(_key_pressed)

func _key_pressed(key_number: int):
	if key_number == 0:
		clear_style(last_active_panel)
	else:
		var panel_name = "Panel" + str(key_number)
		var active_panel = get_node(panel_name)
		clear_style(last_active_panel)
		set_style(active_panel)
		
func set_style(panel: Panel):
	var stylebox = StyleBoxFlat.new()
	stylebox.border_width_left = 8
	stylebox.border_width_right = 8
	stylebox.border_width_top = 8
	stylebox.border_width_bottom = 8
	stylebox.border_color = Color.WHITE
	panel.add_theme_stylebox_override("panel", stylebox)
	last_active_panel = panel
	
func clear_style(panel: Panel):
	var stylebox = StyleBoxFlat.new()
	panel.add_theme_stylebox_override("panel", stylebox)
