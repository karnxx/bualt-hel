extends Node

var upg_name := "NOZZLE"
var min_lvl := 2
var weight := 30
var requires := []
var class_req = 'SPRAY'
func apply_upgrade(plr):
	plr.primscript.max_bullets +=1 
	plr.upgrades_applied.append(self)
