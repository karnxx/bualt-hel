extends Node
var dontwant = ['OVERLOAD','FOCUS','RAGE']
var upg_name := "FUSE+"
var min_lvl := 4
var weight := 30
var requires := ['FUSE']
var class_req = 'BURST'
var desc = "MORE EXPLOSION DMG"
func apply_upgrade(plr):
	plr.upgdata['fuse']['dmg'] += 10
	plr.upgrades_applied.append(self)
