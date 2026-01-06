extends Node

var plr
var mark_target: Node2D = null

func _ready() -> void:
	plr = get_parent()
	plr.homing = true
	plr.upgdata['seek'] = {'seekpower': 70}
	
func on_bullet_fired(bullet):
	bullet.homer =true
	if mark_target and is_instance_valid(mark_target):
		bullet.target = mark_target
	else:
		if get_parent().get_parent().alive > 0:
			bullet.target = near_nemy(plr.get_global_mouse_position())

func near_nemy(pos):
	var enemies = get_tree().get_nodes_in_group("enemy")
	var best
	var best_dist = INF

	for i in enemies:
		var disdis = pos.distance_to(i.global_position)
		if disdis < best_dist:
			best = i
			best_dist = disdis

	return best
