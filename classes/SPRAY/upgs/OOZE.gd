extends Node
var dontwant = ['NOZZLE', 'FANR', 'SHOWER']
var upg_name := "OOZE"
var min_lvl := 3
var weight := 20
var requires := ['POWER-I']
var class_req = 'SPRAY'
var desc = "HIT ENEMY GIVES 3 HEALTH"
func apply_upgrade(plr):
	var scrip = preload("res://classes/SPRAY/upgs/upgscripts/ooze.gd").new()
	plr.add_child(scrip)
	plr.upgrades_applied.append(self)
