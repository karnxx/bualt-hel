extends Node
var dontwant = []
var upg_name := "HEALTHMOUND"
var min_lvl := 0
var weight := 30
var requires := []
var class_req = null

func apply_upgrade(plr):
	plr.health += 50
