extends Node

var upg_name := "POWER-II"
var min_lvl := 0
var weight := 25

func apply_upgrade(player):
	player.current_bullet_dmg += 3
	player.upgrades_applied.append(self)
