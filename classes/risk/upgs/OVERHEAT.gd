extends Node
var dontwant = ['LOSER', 'GLASS', 'REAPER']
var upg_name := "OVERHEAT"
var min_lvl := 2
var weight := 25
var requires := ['POWER-I']
var class_req := 'RISK'

func apply_upgrade(plr):
	plr.max_health -= 40
	plr.current_fire_rate -= 0.3
	plr.upgrades_applied.append(self)
