extends Area3D

var damage_grass = 5
signal get_damage_grass(damage_grass)

func _on_body_entered_grass(body: Node3D) -> void:
	if body.name == "player":
		emit_signal("get_damage_grass")



var damage_wave = 5
signal get_damage_wave(damage_wave)

func _on_body_entered_wave(body: Node3D) -> void:
	if body.name == "player":
		emit_signal("get_damage_wave", damage_wave)



var damage_cat_dog = 5
signal get_damage_cat_dog(damage_cat_dog)

func _on_body_entered_cat_dog(body: Node3D) -> void:
	if body.name == "player":
		emit_signal("get_damage_cat_dog", damage_cat_dog)



var damage_palka = 5
signal get_damage_palka(damage_palka)

func _on_body_entered_palka(body: Node3D) -> void:
	if body.name == "player":
		emit_signal("get_damage_palka", damage_palka)



var damage_chocolate = 5
signal get_damage_chocolate(damage_chocolate)

func _on_body_entered_chocolate(body: Node3D) -> void:
	if body.name == "player":
		emit_signal("get_damage_chocolate", damage_chocolate)



var damage_matcha = 5
signal get_damage_matcha(damage_matcha)

func _on_body_entered_matcha(body: Node3D) -> void:
	if body.name == "player":
		emit_signal("get_damage_matcha", damage_matcha)
