extends Node
var dontwant = []
var upg_name := "SEEKER"
var min_lvl := 2
var weight := 30
var requires := []
var class_req = 'SEEK'
func apply_upgrade(plr):
	plr.upgdata['seek']['seekpower'] += 20
	plr.current_bullet_dmg += 5
	plr.upgrades_applied.append(self)
