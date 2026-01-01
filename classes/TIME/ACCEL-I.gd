extends Node

var upg_name := "ACCEL-I"
var min_lvl := 2
var weight := 50
var requires := ['VELOCITY-I']
var class_req := 'TIME'

func apply_upgrade(plr):
	plr.current_bullet_spd += 200
	plr.upgrades_applied.append(self)
