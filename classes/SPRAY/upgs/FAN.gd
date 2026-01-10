extends Node
var dontwant = ['NOZZLE', 'OOZE', 'SHOWER']
var upg_name := "FANR"
var min_lvl := 1
var weight := 30
var requires := ['SPEEDSTER-I']
var class_req = 'SPRAY'
var desc = "SPREAD GETS INCREASED"
func apply_upgrade(plr):
	plr.upgdata['spray']['fan'] += 20
	plr.upgrades_applied.append(self)
