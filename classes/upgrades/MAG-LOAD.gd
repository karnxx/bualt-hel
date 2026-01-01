extends Node

var upg_name := "MAGLOAD"
var min_lvl := 5
var weight := 40
var requires := ['MAGAZINE']
var class_req = null
func apply_upgrade(plr):
	plr.magazine += 4
	plr.current_bullets += 4
	plr.upgrades_applied.append(self)
