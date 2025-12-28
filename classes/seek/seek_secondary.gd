extends Node

var plr

func secondary(player, _mouse):
	plr = player
	var target = near_nemy(player.global_position)
	if not target:
		return
	print(target)
	plr.passive.mark_target = target
	get_tree().create_timer(3).timeout.connect(dodododod)
	get_tree().create_timer(10).timeout.connect(doneone)

func dodododod():
	if plr and plr.passive:
		plr.passive.mark_target = null

func doneone():
	plr.can_secondary = true

func near_nemy(pos):
	var enemies = get_tree().get_nodes_in_group("enemy")
	var best
	var best_dist = INF

	for i in enemies:
		var disdis = pos.distance_to(i.global_position)
		if disdis < best_dist:
			best =i
			best_dist = disdis

	return best
