extends Node

var upg_name = "SPEEDSTER-I"

func apply_upgrade(player):
	player.current_spd += 50
	player.upgrades_applied.append(self)
