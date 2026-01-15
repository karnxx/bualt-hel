extends Node
var dontwant = ['FUSE','OVERLOAD','RAGE']
var upg_name := "DEEP-FOCUS"
var min_lvl := 5
var weight := 30
var requires := ['FOCUS']
var class_req = 'BURST'
var desc = "FIRES 2 SECONDARY BULLETS"

func apply_upgrade(plr):
	plr.upgdata['burst']['bullets'] += 1
	plr.upgrades_applied.append(self)
