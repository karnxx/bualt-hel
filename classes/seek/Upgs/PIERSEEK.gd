extends Node
var dontwant = []
var upg_name := "PIERSEEK"
var min_lvl := 2
var weight := 30
var requires := []
var class_req = 'SEEK'
func apply_upgrade(plr):
	plr.pierce += 3
	plr.upgrades_applied.append(self)
