extends Area3D

func _ready() -> void:
	# Connect the Area3D's own signals to itself when it comes alive
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	# Look to see if the object that walked into the zone has our player tracking variable
	if "active_gravity_well" in body:
		body.active_gravity_well = self

func _on_body_exited(body: Node3D) -> void:
	if "active_gravity_well" in body and body.active_gravity_well == self:
		body.active_gravity_well = null


func _on_timer_timeout() -> void:
	$bober_teeth_sound.stop()
	$water.stop()
	queue_free()
