extends Node

var upg_name := "POWER-II"
var min_lvl := 2
var weight := 70
var requires := ['POWER-I']
var class_req = null
func apply_upgrade(plr):
	plr.current_bullet_dmg = round(1.15 * plr.current_bullet_dmg)
	plr.upgrades_applied.append(self)
