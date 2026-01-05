extends Node
var dontwant = []
var upg_name := "FANR"
var min_lvl := 2
var weight := 30
var requires := ['SPEED-I']
var class_req = null
func apply_upgrade(plr):
	plr.upgdata['spray']['fan'] += 20
	plr.upgrades_applied.append(self)
