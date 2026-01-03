extends Node
var dontwant = []
var upg_name := "CURSE"
var min_lvl := 1
var weight := 0.1
var requires := []
var class_req := 'RISK'

func apply_upgrade(plr):
	GameManager.global_loot_mult = 1.3
	plr.upgrades_applied.append(self)
