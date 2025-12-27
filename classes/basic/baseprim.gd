extends Node

func primary(plr, mouse):
	var origin = plr.global_position
	var dir = (mouse - origin).normalized()
	var bulat = preload("res://plr/bulet.tscn").instantiate()
	bulat.global_position = origin
	plr.get_parent().add_child(bulat)
	bulat.shoot(plr, dir)
	plr.current_bullets -= 1
