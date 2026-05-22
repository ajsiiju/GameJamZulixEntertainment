extends RichTextLabel

@export var base_font_size: int = 21
@export var reference_width: float = 1920.0

var credits_text = """[color=black][font=LoveYaLikeASister-Regular]
[color=#BF360C]Motion capture Actor[/color]
Kacper Żółty

[color=#311B92]Character Designer[/color]
Kacper Żółty

[color=#004D40]Environment Designer[/color]
Maria Holewka

[color=#0D47A1]Programmers[/color]
Dominika Suda
Przemysław Loll
Ender

[color=#880E4F]Management[/color]
Kacper Żółty
Dominika Suda
Maria Holewka
[/font][/color]"""

func _ready():
	update_text_size()
	get_tree().root.size_changed.connect(update_text_size)

func update_text_size():
	var scale = get_viewport().size.x / reference_width
	var new_size = int(base_font_size * scale)
	text = credits_text
	add_theme_font_size_override("normal_font_size", new_size)
	add_theme_font_size_override("bold_font_size", new_size)
