extends Node
var dontwant = []
var upg_name := "POWER-I"
var min_lvl := 1
var weight := 100
var requires := []
var class_req = null
var desc = "POWER: +10%"
func apply_upgrade(plr):
	plr.current_bullet_dmg = round(1.1 * plr.current_bullet_dmg)
	plr.upgrades_applied.append(self)
