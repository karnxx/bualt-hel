extends Node

var upg_name := "POWER-I"
var min_lvl := 0
var weight := 25
var requires := []
var class_req = null
func apply_upgrade(plr):
	plr.current_bullet_dmg = round(1.08 * plr.current_bullet_dmg)
	plr.upgrades_applied.append(self)
