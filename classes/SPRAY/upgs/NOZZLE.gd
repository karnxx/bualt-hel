extends Node
var dontwant = []
var upg_name := "NOZZLE"
var min_lvl := 2
var weight := 30
var requires := []
var class_req = 'SPRAY'
func apply_upgrade(plr):
	plr.upgdata['spray']['cone'] += 1 
	plr.upgrades_applied.append(self)
