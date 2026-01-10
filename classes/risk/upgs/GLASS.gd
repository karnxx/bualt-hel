extends Node
var dontwant = ['LOSER', 'OVERHEAT', 'REAPER']
var upg_name := "GLASS"
var min_lvl := 1
var weight := 30
var requires := ['POWER-I']
var class_req := 'RISK'
var desc = "LESS MAX HP, +50% DMG"
func apply_upgrade(plr):
	plr.max_health -= 40
	plr.current_bullet_dmg *= 1.50
	plr.upgrades_applied.append(self)
