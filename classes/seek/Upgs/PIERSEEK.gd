extends Node
var dontwant = ['BOOST','SEEKER','SEEKINGS']
var upg_name := "PIERSEEK"
var min_lvl := 2
var weight := 30
var requires := ['POWER-II']
var class_req = 'SEEK'
var desc = "PIERCE: +3"
func apply_upgrade(plr):
	plr.pierce += 3
	plr.upgrades_applied.append(self)
