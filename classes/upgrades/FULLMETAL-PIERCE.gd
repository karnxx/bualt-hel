extends Node
var dontwant = []
var upg_name := "FULLMETAL-PIERCE"
var min_lvl := 12
var weight := 40
var requires := ['VELOCITY-III	','PIERCE']
var class_req = null
func apply_upgrade(plr):
	plr.pierce += 4
	plr.upgrades_applied.append(self)
