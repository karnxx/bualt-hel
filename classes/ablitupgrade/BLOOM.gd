extends Node

var upg_name := "BLOOM"
var min_lvl := 2
var weight := 30
var requires := ['POWER-II','MAGLOAD']
var class_req = null
func apply_upgrade(plr):
	var scrip = preload("res://classes/abilitupgscripts/BLOOM.gd").new()
	scrip.plr = plr
	plr.add_child(scrip)
	plr.upgrades_applied.append(self)
