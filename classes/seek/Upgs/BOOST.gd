extends Node
var dontwant = ['PIERSEEK','SEEKER','SEEKINGS']
var upg_name := "BOOST"
var min_lvl := 2
var weight := 30
var requires := ['VELOCITY-I']
var class_req = 'SEEK'
var desc = "BULLET SPEED INCREASES BY 300"
func apply_upgrade(plr):
	plr.current_bullet_spd += 300
	plr.upgrades_applied.append(self)
