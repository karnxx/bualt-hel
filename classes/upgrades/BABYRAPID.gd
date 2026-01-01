extends Node

var upg_name := "NANO-RAPID"
var min_lvl := 2
var weight := 80
var requires := ['SPEEDSTER-I','VELOCITY-I']
var class_req = null
func apply_upgrade(plr):
	plr.current_fire_rate *= 0.99
	plr.upgrades_applied.append(self)
