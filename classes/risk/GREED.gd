extends Node
var dontwant = []
var upg_name := "GREED"
var min_lvl := 1
var weight := 60
var requires := []
var class_req := 'RISK'
var desc = "1.3X XP AND LOOT"
func apply_upgrade(plr):
	GameManager.global_loot_mult = 1.3
	plr.upgrades_applied.append(self)
