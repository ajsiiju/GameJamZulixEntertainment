extends Area3D

@onready var player = get_tree().get_first_node_in_group("player")
const DAMAGE_WAVE: float = -100.0
const DAMAGE_GRASS: float = -100.0
const DAMAGE_CAT_DOG: float = -50.0
const DAMAGE_PALKA_PION: float = -100.0
const DAMAGE_PALKA_POZIOM: float = -100.0
const DAMAGE_CHOCOLATE: float = -100.0
const DAMAGE_MATCHA: float = -100.0
const DAMAGE_BALLS: float = -100.0
const DAMAGE_BOBER_BULLETS: float = -100.0

const PLAYER_DAMAGE_ON_CAT_DOG: float = 10.0


func _on_body_entered_wave(body: Node3D) -> void:
	if body.is_in_group("player"):
		DebugChat.message("wave")
		player.change_health(DAMAGE_WAVE)


func _on_body_entered_grass(body: Node3D) -> void:
	if body.is_in_group("player"):
		DebugChat.message("grass")
		player.change_health(DAMAGE_GRASS)


func _on_body_entered_cat_dog(body: Node3D) -> void:
	if body.is_in_group("player"):
		DebugChat.message("cat_dog")
		player.change_health(DAMAGE_CAT_DOG)
func projectile_hit():
	get_parent().health -= PLAYER_DAMAGE_ON_CAT_DOG

func _on_body_entered_palka_pion(body: Node3D) -> void:
	if body.is_in_group("player"):
		DebugChat.message("palka_pion")
		player.change_health(DAMAGE_PALKA_PION)


func _on_body_entered_palka_poziom(body: Node3D) -> void:
	if body.is_in_group("player"):
		DebugChat.message("palka_poziom")
		player.change_health(DAMAGE_PALKA_POZIOM)


func _on_body_entered_chocolate(body: Node3D) -> void:
	if body.is_in_group("player"):
		DebugChat.message("chocolate")
		player.change_health(DAMAGE_CHOCOLATE)
		

func _on_body_entered_matcha(body: Node3D) -> void:
	if body.is_in_group("player"):
		DebugChat.message("matcha")
		player.change_health(DAMAGE_MATCHA)


func _on_body_entered_balls(body: Node3D) -> void:
	if body.is_in_group("player"):
		DebugChat.message("balls")
		player.change_health(DAMAGE_BALLS)


func _on_body_entered_bober_bullets(body: Node3D) -> void:
	if body.is_in_group("player"):
		DebugChat.message("bober bullets")
		player.change_health(DAMAGE_BOBER_BULLETS)
    
    
func _on_body_entered_robux(body: Node3D) -> void:
	if body.is_in_group("player"):
		DebugChat.message("robux")
		player.change_social_points(SOCIAL_POINTS_DAMAGE)
