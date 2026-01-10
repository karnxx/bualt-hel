extends Node
var dontwant = []
var upg_name := "DRAG-I"
var min_lvl := 2
var weight := 50
var requires := []
var class_req := 'TIME'
var desc = "ENEMY BULLETS ARE SLOWED"
func apply_upgrade(plr):
	GameManager.global_enemy_bullet_spd -= 100
	plr.upgrades_applied.append(self)
