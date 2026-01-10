extends Node
var dontwant = []
var upg_name := "DEMI"
var min_lvl := 12
var weight := 1
var requires := ['VITALITY-III']
var class_req = null
var desc = "MAX HEALTH: +40%"
func apply_upgrade(plr):
	plr.max_health *= 1.4
	plr.upgrades_applied.append(self)
 
