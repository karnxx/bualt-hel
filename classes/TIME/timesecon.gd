extends Node
var plr
func secondary(d ,_e):
	GameManager.time_scale -= 0.8
	plr = d
	get_tree().create_timer(3).timeout.connect(e)
	get_tree().create_timer(15).timeout.connect(f)

func e():
	GameManager.time_scale = 1.0

func f():
	plr.can_secondary = true
