extends Node
var dontwant = []
var upg_name := "SUPERSONIC"
var min_lvl := 12
var weight := 1
var requires := ['SPEEDSTER-III','POWER-II']
var class_req = null
func apply_upgrade(plr):
	plr.current_spd *= 1.4
	plr.upgrades_applied.append(self)
