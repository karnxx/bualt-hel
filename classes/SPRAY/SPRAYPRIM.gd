extends Node
var max_bullets = 3

var canfire = true
func primary(plr, mouse):
	var origin = plr.get_node('pivot/gun/origin').global_position
	var base_dir = (mouse - origin).normalized()
	canfire = false
	
	var num_bullets = min(plr.upgdata['spray']['cone'], plr.current_bullets)
	if num_bullets <= 0:
		return
	
	var angle_step = deg_to_rad(plr.upgdata['spray']['fan'])
	var half = num_bullets / 2
	for f in range(1,plr.upgdata['spray']['bullets'] + 1):
		for i in range(num_bullets):
			var offset = (i - half + 0.5) * angle_step
			var bulat = plr.bulet.instantiate()
			bulat.pierce = plr.pierce
			bulat.global_position = origin
			bulat.homer = plr.homing
			bulat.chunky = plr.chunky
			bulat.ricochet = plr.ricochet
			bulat.exploding = plr.exploding
			var dir = base_dir.rotated(offset)
			var spread_rad := deg_to_rad(plr.spread_deg)
			dir = dir.rotated(randf_range(-spread_rad, spread_rad))
			plr.get_parent().add_child(bulat)
			bulat.shoot(plr, dir, plr)
		await get_tree().create_timer(0.1).timeout
	plr.current_bullets -= num_bullets
	canfire = true
