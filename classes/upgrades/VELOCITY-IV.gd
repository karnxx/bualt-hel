extends Node
var dontwant = []
var upg_name := "WHOOSHER"
var min_lvl := 12
var weight := 1
var requires := ['VELOCITY-III','SPEEDSTER-II']
var class_req = null
func apply_upgrade(plr):
	plr.current_bullet_spd *= 1.5
	plr.upgrades_applied.append(self)
