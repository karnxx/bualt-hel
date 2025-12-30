extends Node

var upg_name := "SUPERSONIC"
var min_lvl := 10
var weight := 2
var requires := ['SPEEDSTER-III']
var class_req = null
func apply_upgrade(plr):
	plr.current_spd *= 1.4
	plr.upgrades_applied.append(self)
