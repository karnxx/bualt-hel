extends Node

var upg_name := "RAPID-I"
var min_lvl := 2
var weight := 15
var requires := ['SPEEDSTER-II']
var class_req = null
func apply_upgrade(plr):
	plr.current_fire_rate *= 0.97
	plr.upgrades_applied.append(self)
