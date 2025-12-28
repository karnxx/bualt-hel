extends Node

func primary(plr, mouse):
	var origin = plr.global_position
	var dir = (mouse - origin).normalized()

	var bulat = preload("res://classes/seek/bulet.tscn").instantiate()
	bulat.global_position = origin
	plr.get_parent().add_child(bulat)
	bulat.pierce = plr.pierce
	bulat.shoot(plr, dir)
	
	if plr.passive and plr.passive.has_method("on_bullet_fired"):
		plr.passive.on_bullet_fired(bulat)

	plr.current_bullets -= 1
