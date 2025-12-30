extends Node

var upg_name := "FULLMETAL-PIERCE"
var min_lvl := 7
var weight := 2
var requires := ['POWER-II','PIERCE']
var class_req = null
func apply_upgrade(plr):
	plr.pierce += 4
	plr.upgrades_applied.append(self)
