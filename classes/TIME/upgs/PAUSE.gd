extends Node
var dontwant = ['AFTERIMAGE', 'ACCEL', 'SLOWEM']
var upg_name := "PAUSE"
var min_lvl := 6
var weight := 10
var requires := ['POWER-II']
var class_req := 'TIME'
var desc = "TIME GETS PAUSED FOR 0.5S WHEN YOU SHOOT"
func apply_upgrade(plr):
	var script = preload("res://classes/TIME/upgs/scrips/PAUSE.gd").new()
	plr.add_child(script)
	plr.upgrades_applied.append(self)
