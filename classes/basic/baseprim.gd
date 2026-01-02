extends Node

signal fired

func primary(plr, mouse):
	var origin = plr.global_position
	var dir = (mouse - origin).normalized()
	var bulat = plr.bulet.instantiate()
	bulat.pierce = plr.pierce
	bulat.global_position = origin
	plr.get_parent().add_child(bulat)
	bulat.shoot(plr, dir, plr)
	plr.current_bullets -= 1
	emit_signal("fired")
