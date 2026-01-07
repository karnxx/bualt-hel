extends Node
var dontwant = ['AFTERIMAGE', 'PAUSE', 'SLOWEM']
var upg_name := "ACCEL"
var min_lvl := 1
var weight := 50
var requires := ['POWER-I']
var class_req := 'TIME'

func apply_upgrade(plr):
	var script = preload("res://classes/TIME/upgs/scrips/accelscrip.gd").new()
	plr.add_child(script)
	plr.upgrades_applied.append(self)
