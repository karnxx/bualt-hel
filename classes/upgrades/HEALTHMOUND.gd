extends Node

var upg_name := "HEALTHMOUND"
var min_lvl := 0
var weight := 6
var requires := []
var class_req = null

func apply_upgrade(plr):
	plr.health += 50
