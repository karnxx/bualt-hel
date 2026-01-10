extends Node
var dontwant = []
var upg_name = "SPEEDSTER-I"
var min_lvl := 0
var weight := 100
var requires := []
var class_req = null
var desc = "SPEED: +8%"
func apply_upgrade(plr):
	plr.current_spd*= 1.08
	plr.upgrades_applied.append(self)
