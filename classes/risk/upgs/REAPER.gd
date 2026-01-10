extends Node
var dontwant = ['LOSER', 'OVERHEAT', 'GLASS']
var upg_name := "REAPER"
var min_lvl := 5
var weight := 20
var requires := ['THIEF','POWER-I']
var class_req := 'RISK'
var desc = "HP AND BULLETS GAINED ON ENEMY KILL"
func apply_upgrade(plr):
	var Thief = preload("res://classes/ablitupgrade/THIEF.gd").new()
	Thief.apply_upgrade(plr)
	plr.upgdata['thief']['stolen'] = 0.07
	GameManager.global_enemy_dmg_scale = 3.0
	plr.upgrades_applied.append(self)
