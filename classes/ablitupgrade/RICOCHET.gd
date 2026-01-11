extends Node

var upg_name := "RICOCHET"
var min_lvl := 2
var weight := 30
var requires := ['POWER-II','VELOCITY-II']
var class_req = null
var dontwant = ['CHUNK']
var desc = "BULLETS BOUNCE OFF SOLIDS"
func apply_upgrade(plr):
	plr.upgdata['ricochet'] = {"bounces": 1, "spd_dec": 2}
	plr.ricochet = true
	plr.upgrades_applied.append(self)
