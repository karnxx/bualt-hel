extends Node
var plr
func _ready() -> void:
	plr = get_parent()
	plr.connect("fired", asd)

func asd():
	var spd = GameManager.time_scale
	GameManager.time_scale = 0
	print('ahvja')
	await get_tree().create_timer(1).timeout
	GameManager.time_scale = spd
