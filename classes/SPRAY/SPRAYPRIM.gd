extends Node
var max_bullets = 3
func primary(plr, mouse):
	var origin = plr.global_position
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
		plr.get_parent().add_child(bulat)
		bulat.shoot(plr, dir, plr)

	plr.current_bullets -= num_bullets
