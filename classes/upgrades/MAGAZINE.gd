extends Node

var upg_name := "MAGAZINE"
var min_lvl := 1
var weight := 80

var requires := ['VITALITY-I']
var class_req = null
func apply_upgrade(plr):
	plr.magazine += 2
	plr.current_bullets += 2
	plr.upgrades_applied.append(self)
