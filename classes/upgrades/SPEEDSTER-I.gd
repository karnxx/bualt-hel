extends Node

var upg_name = "SPEEDSTER-I"
var min_lvl := 0
var weight := 25
func apply_upgrade(plr):
	plr.current_spd += 50
	plr.upgrades_applied.append(self)
