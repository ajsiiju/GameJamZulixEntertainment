extends Label

var timer: float = 5.0

func _ready() -> void:
	visible = false
	set_process(false)
	var main = get_tree().get_first_node_in_group("main")
	main.ad_appear_counter.connect(ad_appear_counter)

func ad_appear_counter():
	timer = 5.0
	visible = true
	set_process(true)

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		visible = false
		set_process(false)
	else:
		text = "   AD WILL APPEAR IN " + "%01d" % (int(ceil(timer)) % 10) + "s"
	
