extends Node
var pdlr
func secondary(plr, mouse):
	var origin = plr.get_node('pivot/gun/origin').global_position
	pdlr = plr
	var base_dir = (mouse - origin).normalized()
	var max_bullets = 10
	var num_bullets = min(max_bullets, plr.current_bullets)
	if num_bullets <= 0:
		return
	
	var angle_step = deg_to_rad(18)
	var half = num_bullets / 2

	for i in range(num_bullets):
		var offset = (i - half + 0.5) * angle_step
		var bulat = plr.bulet.instantiate()
		bulat.global_position = origin
		bulat.pierce = plr.pierce
		var dir = base_dir.rotated(offset)
		plr.get_parent().add_child(bulat)
		bulat.shoot(plr, dir, plr)

	plr.current_bullets -= num_bullets
	
	get_tree().create_timer(10).timeout.connect(done)

func done():
	pdlr.can_secondary = true
