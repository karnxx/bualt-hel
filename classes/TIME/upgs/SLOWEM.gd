extends Node
var dontwant = ['AFTERIMAGE', 'PAUSE', 'ACCEL']
var upg_name := "SLOWEM"
var min_lvl := 3
var weight := 30
var requires := ['SPEEDSTER-I']
var class_req := 'TIME'
var desc = "HIT ENEMY SLOWS DOWN FOR SOME TIME"
func apply_upgrade(plr):
	var script = preload("res://classes/TIME/upgs/scrips/slowem.gd").new()
	plr.add_child(script)
	plr.upgrades_applied.append(self)
