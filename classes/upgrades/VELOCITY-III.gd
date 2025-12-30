extends Node

var upg_name := "VELOCITY-II"
var min_lvl := 4
var weight := 3
var requires := ['VELOCITY-I']
var class_req = null
func apply_upgrade(plr):
	plr.current_bullet_spd *= 1.3
	plr.upgrades_applied.append(self)
