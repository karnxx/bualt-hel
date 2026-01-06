extends Node
var dontwant = []
var upg_name := "SEEK"
var min_lvl := 2
var weight := 30
var requires := []
var class_req = 'SEEK'
func apply_upgrade(plr):
	plr.upgdata['seek'] = {'seekpower': 5}
	plr.upgrades_applied.append(self)
