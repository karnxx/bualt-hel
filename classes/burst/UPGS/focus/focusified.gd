extends Node
var dontwant = ['FUSE','OVERLOAD','RAGE']
var upg_name := "focusified"
var min_lvl := 5
var weight := 30
var requires := ['FOCUS']
var class_req = 'BURST'
var desc = " + PIERCE"

func apply_upgrade(plr):
	plr.pierce += 3
	plr.upgrades_applied.append(self)
