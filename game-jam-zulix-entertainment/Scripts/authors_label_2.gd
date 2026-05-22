extends RichTextLabel

@export var base_font_size: int = 21
@export var reference_width: float = 1920.0

var credits_text = """[color=black][font=LoveYaLikeASister-Regular]
[color=#1A237E]2D Artists[/color]
Maja Bryl
Paulina Kopeć 
Julia Cieślar 
Barbara Mrówka 
Kacper Żółty 

[color=#0D47A1]3D Artists[/color]
Maja Bryl 
Gleb Chemodanov

[color=#4A148C]2D Animator[/color]
Paulina Kopeć
Julia Cieślar

[color=#1B5E20]Sound Designer[/color]
Julia Cieślar

[color=#BF360C]Motion capture UI Designer[/color]
Barbara Mrówka
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
