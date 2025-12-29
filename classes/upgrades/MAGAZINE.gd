extends Node

var upg_name := "MAGAZINE-I"
var min_lvl := 0
var weight := 20
var requires := []
var class_req = null
func apply_upgrade(plr):
	plr.magazine += 2
	plr.upgrades_applied.append(self)
