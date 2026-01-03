extends Node
var dontwant = []
var upg_name := "THIEF"
var min_lvl := 2
var weight := 30
var requires := ['POWER-II','VITALITY-I']
var class_req = null
func apply_upgrade(plr):
	plr.max_health -= 40
	plr.health -= 20
	var scrip = preload("res://classes/abilitupgscripts/THIEF.gd").new()
	plr.add_child(scrip)
	scrip.plr = plr
	plr.upgdata['thief'] = {"stolen": 0.03}
	plr.upgrades_applied.append(self)
