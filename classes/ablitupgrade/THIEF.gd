extends Node

var upg_name := "THIEF"
var min_lvl := 0
var weight := 100
var requires := []#'POWER-II','VITALITY-I']
var class_req = null
func apply_upgrade(plr):
	plr.max_health -= 40
	plr.health -= 20
	var scrip = preload("res://classes/abilitupgscripts/THIEF.gd").new()
	plr.add_child(scrip)
	scrip.plr = plr
	plr.upgrades_applied.append(self)
