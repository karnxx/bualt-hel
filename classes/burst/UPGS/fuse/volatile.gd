extends Node
var dontwant = ['OVERLOAD','FOCUS','RAGE']
var upg_name := "VOLATILE"
var min_lvl := 4
var weight := 30
var requires := ['FUSE']
var class_req = 'BURST'
var desc = "MORE EXPLOSION RADIUS"
func apply_upgrade(plr):
	plr.upgdata['fuse']['radius'] = 70
	plr.upgrades_applied.append(self)
