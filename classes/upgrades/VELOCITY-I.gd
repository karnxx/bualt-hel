extends Node
var dontwant = []
var upg_name := "VELOCITY-I"
var min_lvl := 0
var weight := 100
var requires := []
var class_req = null
func apply_upgrade(plr):
	plr.current_bullet_spd *= 1.1
	plr.upgrades_applied.append(self)
