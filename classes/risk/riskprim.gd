extends Node

signal fired

func primary(plr, mouse):
	var origin = plr.global_position
	var dir = (mouse-origin).normalized()
	
	var missing = 1.0 - float(plr.health) / plr.max_health
	var multt = lerp(1.0,2.5,missing)
	
	var bulat = plr.bulet.instantiate()
	bulat.global_position = origin
	plr.get_parent().add_child(bulat)
	bulat.shoot(plr, dir, plr)
	bulat.dmg *= multt
	emit_signal('fired')
