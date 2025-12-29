extends Node
var plr
var spd
var firate
func _ready() -> void:
	plr = owner

func _process(_delta):
	if not owner:
		return
	
	spd = plr.current_spd
	firate = plr.current_fire_rate
	if float(plr.health) / plr.max_health < 0.3:
		plr.current_spd = plr.base_spd * 1.3
		plr.current_fire_rate = plr.base_fire_rate * 0.7
	else:
		plr.current_spd = spd
		plr.current_fire_rate = firate
