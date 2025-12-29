extends Node

var upg_name := "PIERCE-I"
var min_lvl := 2
var weight := 16
var requires := ['POWER-II']
var class_req = null
func apply_upgrade(plr):
	plr.pierce += 1
	plr.upgrades_applied.append(self)
