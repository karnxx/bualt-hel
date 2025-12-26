extends Node

var upg_name := "RAPID FIRE-I"
var min_lvl := 2
var weight := 15

func apply_upgrade(plr):
	plr.current_fire_rate = 0.85*plr.base_fire_rate
	plr.upgrades_applied.append(self)
