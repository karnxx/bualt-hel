extends Node

var upg_name := "MAGLOAD"
var min_lvl := 3
var weight := 20
var requires := ['MAGAZINE']
var class_req = null
func apply_upgrade(plr):
	plr.magazine += 4
	plr.upgrades_applied.append(self)
