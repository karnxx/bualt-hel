extends Node

signal fired


func primary(plr, mouse):
	var origin = plr.get_node('pivot/gun/origin').global_position
	var dir = (mouse - origin).normalized()

	var bulat = plr.bulet.instantiate()
	var spread_rad := deg_to_rad(plr.spread_deg)
	dir = dir.rotated(randf_range(-spread_rad, spread_rad))
	bulat.global_position = origin
	plr.get_parent().add_child(bulat)
	bulat.pierce = plr.pierce
	bulat.shoot(plr, dir, plr)
	
	if plr.passive and plr.passive.has_method("on_bullet_fired"):
		plr.passive.on_bullet_fired(bulat)

	plr.current_bullets -= 1
	emit_signal('fired')
