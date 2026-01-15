extends Node
var dontwant = []
var upg_name := "BURST"
var min_lvl := 5
var weight := 30
var requires := []
var class_req = 'BURST'
var desc = ""

func apply_upgrade(plr):
	plr.upgdata['burst'] = {'bullets': 1, 'smallers' : 0}
	plr.upgrades_applied.append(self)
