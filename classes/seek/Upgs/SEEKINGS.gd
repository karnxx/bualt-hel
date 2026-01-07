extends Node
var dontwant = ['PIERSEEK','SEEKER','BOOST']
var upg_name := "SEEKINGS"
var min_lvl := 4
var weight := 20
var requires := ['POWER-I', 'SPEEDSTER-I']
var class_req = 'SEEK'
func apply_upgrade(plr):
	var Seekingsscript = preload("res://classes/seek/Upgs/scripars/seekingsscript.gd").new()
	plr.add_child(Seekingsscript)
	plr.upgrades_applied.append(self)
