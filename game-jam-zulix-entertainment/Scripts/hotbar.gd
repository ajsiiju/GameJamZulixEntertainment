extends HBoxContainer

@onready var last_active_panel: Panel = $Panel1
var style_box_default
var style_highlighted_box

func _ready() -> void:
	create_styles()
	var player = get_tree().get_first_node_in_group("player")
	player.hotbar_key_pressed.connect(_key_pressed)
	player.hotbar_icon_unlocked.connect(_icon_unlocked)
	
func _key_pressed(key_number: int):
	if key_number != 0:
		var panel_name = "Panel" + str(key_number)
		blink_highlight(get_node(panel_name))

func _icon_unlocked(icon_number: int):
	var panel_name = "Panel" + str(icon_number)
	get_node(panel_name + "/TextureRect").visible = true

func create_styles():
	style_box_default = StyleBoxFlat.new()
	style_box_default.border_color = Color.WHITE
	style_box_default.bg_color = Color(0, 0, 0, 0.15)
	style_highlighted_box = StyleBoxFlat.new()
	style_box_default.border_color = Color.WHITE
	style_box_default.bg_color = Color(0, 0, 0, 0.15)
	style_highlighted_box.border_width_left = 8
	style_highlighted_box.border_width_right = 8
	style_highlighted_box.border_width_top = 8
	style_highlighted_box.border_width_bottom = 8

func blink_highlight(panel: Panel):
	panel.add_theme_stylebox_override("panel", style_highlighted_box)
	get_tree().create_timer(0.1).timeout.connect(
		func():
			panel.add_theme_stylebox_override("panel", style_box_default),
			CONNECT_ONE_SHOT
	)


func clear_style(panel: Panel):
	var stylebox = StyleBoxFlat.new()
	panel.add_theme_stylebox_override("panel", stylebox)
