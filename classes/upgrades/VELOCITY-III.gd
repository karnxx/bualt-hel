extends Node
var dontwant = []
var upg_name := "VELOCITY-II"
var min_lvl := 5
var weight := 40
var requires := ['VELOCITY-I']
var class_req = null
func apply_upgrade(plr):
	plr.current_bullet_spd *= 1.3
	plr.upgrades_applied.append(self)
