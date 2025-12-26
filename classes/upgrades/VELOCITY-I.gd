extends Node

var upg_name := "VELOCITY-I"
var min_lvl := 0
var weight := 20

func apply_upgrade(player):
	player.current_bullet_spd += 70
	player.upgrades_applied.append(self)
