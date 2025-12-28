extends Node

var upg_name := "VELOCITY-II"
var min_lvl := 1
var weight := 6
var requires := ['VELOCITY-I']

func apply_upgrade(plr):
	plr.current_bullet_spd *= 1.2
	plr.upgrades_applied.append(self)
