extends Node

var upg_name := "SHIELD"
var min_lvl := 2
var weight := 30
var requires := ['VITALITY-I','POWER-I']
var class_req = null
func apply_upgrade(plr):
	const SHIELD = preload("res://classes/abilitupgscripts/SHIELD.tscn")
	var shield = SHIELD.instantiate()
	plr.add_child(shield)
	plr.upgdata['shield'] = {'time':3}
	plr.upgrades_applied.append(self)
