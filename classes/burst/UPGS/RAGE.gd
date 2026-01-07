extends Node
var dontwant = ['FUSE','FOCUS','OVERLOAD']
var upg_name := "RAGE"
var min_lvl := 4
var weight := 30
var requires := ['POWER-I', 'VITALITY-I']
var class_req = 'BURST'
func apply_upgrade(plr):
	var script = preload("res://classes/burst/UPGS/upgscrips/RAGESCRIP.gd").new()
	script.plr = plr
	plr.add_child(script)
	plr.upgrades_applied.append(self)
