extends Node
var dontwant = []
var upg_name := "SPEEDSTER-III"
var min_lvl := 5
var weight := 40
var requires := ['SPEEDSTER-II']
var class_req = null
var desc = "SPEED: +25%"
func apply_upgrade(plr):
	plr.current_spd *= 1.25
	plr.upgrades_applied.append(self)
