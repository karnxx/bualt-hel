extends Node
var dontwant = []
var upg_name := "BOOST"
var min_lvl := 2
var weight := 30
var requires := []
var class_req = 'SEEK'
func apply_upgrade(plr):
	plr.current_bullet_spd += 300
	plr.upgrades_applied.append(self)
