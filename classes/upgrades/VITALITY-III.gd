extends Node

var upg_name := "DEMI"
var min_lvl := 10
var weight := 20
var requires := ['VITALITY-III']
var class_req = null
func apply_upgrade(plr):
	plr.max_health *= 1.5
	plr.upgrades_applied.append(self)
 
