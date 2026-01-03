extends Node
var dontwant = []
var upg_name := "HEALTH-HORDE"
var min_lvl := 0
var weight := 2
var requires := []
var class_req = null

func apply_upgrade(plr):
	plr.health += 100
