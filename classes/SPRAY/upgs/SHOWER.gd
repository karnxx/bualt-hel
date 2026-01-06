extends Node
var dontwant = []
var upg_name := "SHOWER"
var min_lvl := 2
var weight := 30
var requires := ['VITALITY-II','POWER-I']
var class_req = 'SPRAY'
func apply_upgrade(plr):
	plr.upgdata['spray']['bullets'] += 1
	plr.upgrades_applied.append(self)
