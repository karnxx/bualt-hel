extends Node
var dontwant = ['NOZZLE', 'OOZE', 'FANR']
var upg_name := "SHOWER"
var min_lvl := 4
var weight := 20
var requires := ['VITALITY-I','POWER-I','MAGAZINE']
var class_req = 'SPRAY'
var desc = "FIRES 2 ROUNDS OF BULLETS"
func apply_upgrade(plr):
	plr.upgdata['spray']['bullets'] += 1
	plr.upgrades_applied.append(self)
