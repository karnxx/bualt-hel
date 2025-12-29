extends Node
var plr
func secondary(d ,_e):
	GameManager.time_scale -= 0.95
	plr = d
	get_tree().create_timer(5).timeout.connect(e)
	get_tree().create_timer(10).timeout.connect(f)

func e():
	GameManager.time_scale = 1.0

func f():
	plr.can_secondary = true
