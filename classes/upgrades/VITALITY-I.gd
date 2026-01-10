extends Node
var dontwant = []
var upg_name := "VITALITY-I"
var min_lvl := 0
var weight := 100
var requires := []
var class_req = null
var desc = "MAX HEALTH: +10%"
func apply_upgrade(plr):
	plr.max_health *= 1.1
	plr.upgrades_applied.append(self)
 
