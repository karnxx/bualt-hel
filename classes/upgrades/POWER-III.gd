extends Node

var upg_name := "POWER-III"
var min_lvl := 5
var weight := 40
var requires := ['POWER-II']
var class_req = null
func apply_upgrade(plr):
	plr.current_bullet_dmg = round(1.25 * plr.current_bullet_dmg)
	plr.upgrades_applied.append(self)
