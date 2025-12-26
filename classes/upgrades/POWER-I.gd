extends Node

var upg_name := "POWER-I"
var min_lvl := 0
var weight := 25

func apply_upgrade(plr):
	plr.current_bullet_dmg += 3
	plr.upgrades_applied.append(self)
