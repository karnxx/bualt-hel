extends Node
var dontwant = ['FUSE','OVERLOAD','RAGE']
var upg_name := "FOCUS"
var min_lvl := 5
var weight := 30
var requires := ['VITALITY-I', 'SPEED-I']
var class_req = 'BURST'
func apply_upgrade(plr):
	plr.current_bullet_dmg += 10
	plr.current_bullet_spd = 500
	plr.current_speed -= 100
	plr.upgrades_applied.append(self)
