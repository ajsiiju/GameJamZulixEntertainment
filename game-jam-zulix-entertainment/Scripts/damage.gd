extends Area3D

#@onready var player = get_tree().get_first_node_in_group("player")
#
#var damage_wave = -5
#func _on_body_entered_wave(body: Node3D) -> void:
	#if body.is_in_group("player"):
		#player.change_health.emit(damage_wave)


var damage_grass = 5
signal get_damage_grass(damage_grass)

func _on_body_entered_grass(body: Node3D) -> void:
	if body.name == "player":
		emit_signal("get_damage_grass")



var damage_cat_dog = 5
signal get_damage_cat_dog(damage_cat_dog)

func _on_body_entered_cat_dog(body: Node3D) -> void:
	if body.name == "player":
		emit_signal("get_damage_cat_dog", damage_cat_dog)



var damage_palka_pion = 5
signal get_damage_palka_pion(damage_palka_pion)

func _on_body_entered_palka_pion(body: Node3D) -> void:
	if body.name == "player":
		emit_signal("get_damage_palka_pion", damage_palka_pion)



var damage_palka_poziom = 5
signal get_damage_palka_poziom(damage_palka_poziom)

func _on_body_entered_palka_poziom(body: Node3D) -> void:
	if body.name == "player":
		emit_signal("get_damage_palka_poziom", damage_palka_poziom)



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



var damage_balls = 5
signal get_damage_balls(damage_balls)

func _on_body_entered_balls(body: Node3D) -> void:
	if body.name == "player":
		emit_signal("get_damage_balls", damage_balls)
