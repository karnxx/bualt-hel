extends Node
var dontwant = []
var upg_name := "BLOOM"
var min_lvl := 2
var weight := 30
var requires := ['POWER-II','MAGLOAD']
var class_req = null
var desc = "EVERY SHOTS RELEASES A 3 BULLET SHOT"
func apply_upgrade(plr):
	var scrip = preload("res://classes/abilitupgscripts/BLOOM.gd").new()
	scrip.plr = plr
	plr.add_child(scrip)
	plr.upgdata['bloom'] = {'bloombul':3, 'bloomfan':120}
	plr.upgrades_applied.append(self)
