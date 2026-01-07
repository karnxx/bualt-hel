extends Node
var plr
var canpause = true

func _ready() -> void:
	plr = get_parent()
	plr.connect("fired", asd)

func asd():
	if canpause == false:
		return
	var spd = GameManager.time_scale
	GameManager.time_scale = 0
	canpause = false
	await get_tree().create_timer(0.5).timeout
	GameManager.time_scale = spd
	await get_tree().create_timer(4).timeout
	canpause = true
