extends Node
var dontwant = []
var upg_name := "RAPID"
var min_lvl := 2
var weight := 60
var requires := ['SPEEDSTER-II','NANO-RAPID']
var class_req = null
func apply_upgrade(plr):
	plr.current_fire_rate *= 0.96
	plr.upgrades_applied.append(self)
