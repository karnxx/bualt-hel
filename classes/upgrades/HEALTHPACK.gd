extends Node

var upg_name := "HEALTHPACK"
var min_lvl := 0
var weight := 15
var requires := []
func apply_upgrade(plr):
	plr.health += 20
