extends Node

var upg_name := "CHUNK"
var min_lvl := 2
var weight := 30
var requires := ['POWER-I','MAGAZINE']
var class_req = null
var dontwant = ['RICOCHET']
var desc = "BULLETS SPLIT INTO 2"
func apply_upgrade(plr):
	plr.chunky = true
	plr.upgdata['chunky'] = {'chunkmult': 4, "chunks": 2}
	plr.upgrades_applied.append(self)
