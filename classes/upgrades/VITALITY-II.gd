extends Node
var dontwant = []
var upg_name := "VITALITY-II"
var min_lvl := 2
var weight := 70
var requires := ["VITALITY-I"]
var class_req = null
var desc = "MAX HEALTH: +20%"
func apply_upgrade(plr):
	plr.max_health *= 1.2
	plr.upgrades_applied.append(self)
 
