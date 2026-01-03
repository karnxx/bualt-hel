extends Node
var dontwant = []
var upg_name := "DEMI"
var min_lvl := 12
var weight := 1
var requires := ['VITALITY-III']
var class_req = null
func apply_upgrade(plr):
	plr.max_health *= 1.5
	plr.upgrades_applied.append(self)
 
