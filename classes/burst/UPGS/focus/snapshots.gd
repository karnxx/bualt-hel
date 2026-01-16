extends Node
var dontwant = ['FUSE','OVERLOAD','RAGE', 'FOCUSIFIED','DEEP-FOCUS']
var upg_name := "SNAPSHOTS"
var min_lvl := 5
var weight := 30
var requires := ['FOCUS']
var class_req = 'BURST'
var desc = "FIRES 2 SMALL BULLETS IN SECONDARY"

func apply_upgrade(plr):
	plr.upgdata['burst']['smallers'] += 2
	plr.upgrades_applied.append(self)
