extends Node
var dontwant = ['OVERLOAD','FOCUS','RAGE']
var upg_name := "CHAIN"
var min_lvl := 4
var weight := 30
var requires := ['FUSE']
var class_req = 'BURST'
var desc = "WHEN ENEMIES DIE, EXPLOSION SPAWNS"
func apply_upgrade(plr):
	plr.upgdata['fuse']['chain'] = true
	plr.upgrades_applied.append(self)
