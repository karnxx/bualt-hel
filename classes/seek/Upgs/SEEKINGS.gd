extends Node
var dontwant = []
var upg_name := "SEEKINGS"
var min_lvl := 2
var weight := 30
var requires := []
var class_req = 'SEEK'
func apply_upgrade(plr):
	var Seekingsscript = preload("res://classes/seek/Upgs/scripars/seekingsscript.gd").new()
	plr.add_child(Seekingsscript)
	plr.upgrades_applied.append(self)
