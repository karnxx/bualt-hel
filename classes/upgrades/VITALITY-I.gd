extends Node

var upg_name := "VITALITY-I"
var min_lvl := 0
var weight := 20
var requires := []
var class_req = null
func apply_upgrade(plr):
	plr.max_health *= 1.1
	plr.upgrades_applied.append(self)
 
