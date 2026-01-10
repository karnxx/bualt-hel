extends Node
var dontwant = ['GLASS', 'OVERHEAT', 'REAPER']
var upg_name := "LOSER"
var min_lvl := 1
var weight := 60
var requires := []
var class_req := 'RISK'
var desc = "SUCH A LOSER.. +40 MAX HP, ENEMY DMG MODIFIER REDUCED TO 1"
func apply_upgrade(plr):
	plr.max_health += 40
	GameManager.global_enemy_dmg_scale = 1
	plr.current_bullet_dmg = 10
	plr.upgrades_applied.append(self)
