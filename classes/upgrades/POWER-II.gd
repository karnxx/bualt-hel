extends Node

var upg_name := "POWER-II"
var min_lvl := 1
var weight := 8
var requires := ['POWER-I']

func apply_upgrade(plr):
	plr.current_bullet_dmg = round(1.15 * plr.current_dmg)
	plr.upgrades_applied.append(self)
