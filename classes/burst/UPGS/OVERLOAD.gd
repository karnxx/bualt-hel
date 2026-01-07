extends Node
var dontwant = ['FUSE','FOCUS','RAGE']
var upg_name := "OVERLOAD"
var min_lvl := 3
var weight := 70
var requires := ['POWER-I','MAGAZINE']
var class_req = 'BURST'
func apply_upgrade(plr):
	var scrip = preload("res://classes/burst/UPGS/upgscrips/OVERLOADSCRIP.gd").new()
	scrip.plr = plr
	plr.add_child(scrip)
	plr.upgdata['overload'] = {'shots':3, 'dmgmult':2.0}
	plr.upgrades_applied.append(self)
