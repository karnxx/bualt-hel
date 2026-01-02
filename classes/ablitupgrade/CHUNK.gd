extends Node

var upg_name := "CHUNK"
var min_lvl := 2
var weight := 30
var requires := ['POWER-I','MAGAZINE']
var class_req = null
func apply_upgrade(plr):
	plr.bulet = preload("res://plr/chunkybullet.tscn")
	plr.upgdata['chunkmult'] = 4
	plr.upgrades_applied.append(self)
