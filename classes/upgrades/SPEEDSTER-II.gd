extends Node

var upg_name := "SPEEDSTER-II"
var min_lvl := 1
var weight := 8

func apply_upgrade(player):
	player.current_spd += 100
	player.upgrades_applied.append(self)
