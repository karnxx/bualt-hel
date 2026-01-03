extends Node
var dontwant = []
var upg_name := "HEALTHPACK"
var min_lvl := 0
var weight := 70
var requires := []
var class_req = null

func apply_upgrade(plr):
	plr.health += 20
