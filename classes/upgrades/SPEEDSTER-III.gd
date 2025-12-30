extends Node

var upg_name := "SPEEDSTER-III"
var min_lvl := 6
var weight := 8
var requires := ['SPEEDSTER-II']
var class_req = null
func apply_upgrade(plr):
	plr.current_spd *= 1.12
	plr.upgrades_applied.append(self)
