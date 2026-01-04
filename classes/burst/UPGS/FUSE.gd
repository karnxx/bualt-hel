extends Node
var dontwant = []
var upg_name := "FUSE"
var min_lvl := 4
var weight := 30
var requires := ['POWER-I']
var class_req = 'BURST'
func apply_upgrade(plr):
	plr.exploding = true
	plr.upgrades_applied.append(self)
