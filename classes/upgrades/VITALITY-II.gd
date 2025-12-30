extends Node

var upg_name := "VITALITY-I"
var min_lvl := 5
var weight := 20
var requires := ["VITALITY-II"]
var class_req = null
func apply_upgrade(plr):
	plr.max_health *= 1.3
	plr.upgrades_applied.append(self)
 
