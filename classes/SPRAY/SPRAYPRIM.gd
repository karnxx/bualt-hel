extends Node

func primary(plr, mouse):
	var origin = plr.global_position
	var base_dir = (mouse - origin).normalized()
	var spread_angle = deg_to_rad(10)

	for angle in [-spread_angle, 0, spread_angle]:
		var bulat = preload("res://plr/bulet.tscn").instantiate()
		bulat.global_position = origin
		var dir = base_dir.rotated(angle)
		plr.get_parent().add_child(bulat)
		bulat.shoot(plr, dir)

	plr.current_bullets -= 3
