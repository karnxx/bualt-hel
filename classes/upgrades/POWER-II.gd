extends Node

var upg_name := "POWER-II"
var min_lvl := 1
var weight := 8

func apply_upgrade(plr):
	plr.current_bullet_dmg += 7
	plr.upgrades_applied.append(self)
