extends Node

var upg_name := "POWER-I"
var min_lvl := 1
var weight := 25

func apply_upgrade(player):
	player.current_bullet_dmg += 7
	player.upgrades_applied.append(self)
