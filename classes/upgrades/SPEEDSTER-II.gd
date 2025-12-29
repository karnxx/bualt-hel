extends Node

var upg_name := "SPEEDSTER-II"
var min_lvl := 1
var weight := 8
var requires := ['SPEEDSTER-I']
var class_req = null
func apply_upgrade(plr):
	plr.current_spd *= 1.12
	plr.upgrades_applied.append(self)
