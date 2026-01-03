extends Node
var dontwant = []
var upg_name := "PIERCE"
var min_lvl := 2
var weight := 70
var requires := ['VELOCITY-II']
var class_req = null
func apply_upgrade(plr):
	plr.pierce += 1
	plr.upgrades_applied.append(self)
