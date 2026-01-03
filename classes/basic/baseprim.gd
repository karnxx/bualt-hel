extends Node

signal fired

func primary(plr, mouse):
	var origin = plr.get_node('pivot/gun/origin').global_position
	var dir = (mouse - origin).normalized()
	var bulat = plr.bulet.instantiate()
	var spread_rad := deg_to_rad(plr.spread_deg)
	dir = dir.rotated(randf_range(-spread_rad, spread_rad))
	
	bulat.pierce = plr.pierce
	bulat.global_position = origin
	plr.get_parent().add_child(bulat)
	bulat.shoot(plr, dir, plr)
	plr.current_bullets -= 1
	emit_signal("fired")
