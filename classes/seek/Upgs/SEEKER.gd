extends Node
var dontwant = ['PIERSEEK','BOOST','SEEKINGS']
var upg_name := "SEEKER"
var min_lvl := 3
var weight := 20
var requires := ['POWER-I', 'VELOCITY-I']
var class_req = 'SEEK'
func apply_upgrade(plr):
	plr.upgdata['seek']['seekpower'] += 20
	plr.current_bullet_dmg += 5
	plr.upgrades_applied.append(self)
