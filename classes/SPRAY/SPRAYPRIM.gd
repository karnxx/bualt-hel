extends Node
var max_bullets = 3

signal fired

func primary(plr, mouse):
	var origin = plr.get_node('pivot/gun/origin').global_position
	var base_dir = (mouse - origin).normalized()


	var num_bullets = min(max_bullets, plr.current_bullets)
	if num_bullets <= 0:
		return
	
	var angle_step = deg_to_rad(10)
	var half = num_bullets / 2

	for i in range(num_bullets):
		var offset = (i - half + 0.5) * angle_step
		var bulat = plr.bulet.instantiate()
		bulat.pierce = plr.pierce
		bulat.global_position = origin
		var dir = base_dir.rotated(offset)
		var spread_rad := deg_to_rad(plr.spread_deg)
		dir = dir.rotated(randf_range(-spread_rad, spread_rad))
		plr.get_parent().add_child(bulat)
		bulat.shoot(plr, dir, plr)

	plr.current_bullets -= num_bullets
	emit_signal('fired')
