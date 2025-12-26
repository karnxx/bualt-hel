extends Node

var upg_name := "VELOCITY-I"
var min_lvl := 0
var weight := 20

func apply_upgrade(plr):
	plr.current_bullet_spd += 70
	plr.upgrades_applied.append(self)
