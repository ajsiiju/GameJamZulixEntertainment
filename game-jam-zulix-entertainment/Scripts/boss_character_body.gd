extends CharacterBody3D

# for detecting if hit by player's projectile
@onready var node_3d: Node3D = $"../.."
var damage = Callable(self, "deal_damage")

func deal_damage(amount): # activates when the boss is hit by player's projectile
	# btw i had to do it through the main node cuz otherwise it wasn't working
	node_3d.points.call(10)
