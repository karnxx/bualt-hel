extends Node
var dontwant = []
var upg_name := "SHOCKWAVE"
var min_lvl := 2
var weight := 30
var requires := ['POWER-II','VITALITY-II']
var class_req = null
func apply_upgrade(plr):
	var scrip = preload("res://classes/abilitupgscripts/SHOCKWAV.tscn").instantiate()
	plr.add_child(scrip)
	scrip.plr = plr
	plr.upgdata['shockwave'] = {'power': 700, "range": 23}
	plr.upgrades_applied.append(self)
