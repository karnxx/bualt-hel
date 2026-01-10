extends Node

var upg_name := "VITALITY-III"
var min_lvl := 5
var weight := 40
var requires := ['VITALITY-II','POWER-III']
var class_req = null
var desc = "MAX HEALTH: +30%"
func apply_upgrade(plr):
	plr.max_health *= 1.3
	plr.upgrades_applied.append(self)
 
