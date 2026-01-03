extends Node
var dontwant = []
var upg_name := "SPEEDSTER-II"
var min_lvl := 2
var weight :=70
var requires := ['SPEEDSTER-I']
var class_req = null
func apply_upgrade(plr):
	plr.current_spd *= 1.12
	plr.upgrades_applied.append(self)
