extends Node

var plr
var mark_target: Node2D = null

func attach(player):
	plr = player

func on_bullet_fired(bullet):
	if mark_target and is_instance_valid(mark_target):
		bullet.target = mark_target
	else:
		bullet.target = near_nemy(bullet.global_position)

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
