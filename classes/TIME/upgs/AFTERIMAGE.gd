extends Node
var dontwant = ['ACCEL', 'PAUSE', 'SLOWEM']
var upg_name := "AFTERIMAGE"
var min_lvl := 2
var weight := 30
var requires := ['POWER-I', 'SPEEDSTER-I']
var class_req := 'TIME'
var desc = "BULLETS LEAVE AFTERIMAGES, WHICH DMG ENEMIES"
func apply_upgrade(plr):
	var script = preload("res://classes/TIME/upgs/scrips/afterimage.gd").new()
	plr.add_child(script)
	plr.upgrades_applied.append(self)
