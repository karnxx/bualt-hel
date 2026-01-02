extends Node

var upg_name := "BLOOM"
var min_lvl := 2
var weight := 30
var requires := ['POWER-I','RAPID']
var class_req = null
func apply_upgrade(plr):

	plr.upgrades_applied.append(self)
