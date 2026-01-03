extends Node
var dontwant = []
var upg_name := "WARGOD"
var min_lvl := 12
var weight := 1
var requires := ['POWER-III']
var class_req = null
func apply_upgrade(plr):
	plr.current_bullet_dmg = round(1.25 * plr.current_bullet_dmg)
	plr.upgrades_applied.append(self)
