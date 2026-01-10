extends Node
var dontwant = []
var upg_name := "CURSE"
var min_lvl := 1
var weight := 0.1
var requires := []
var class_req := 'RISK'
var desc = "2X DMG FROM ALL ENEMIES"
func apply_upgrade(plr):
	GameManager.global_enemy_dmg_scale = 2.0
	plr.upgrades_applied.append(self)
