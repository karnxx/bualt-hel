extends Node
var plr
var count = 0
var dmg
var rate
func _ready() -> void:
	plr = get_parent()
	plr.connect('plr_secon',secon)
	plr.connect('fired',prim)

func secon():
	dmg = plr.current_bullet_dmg
	rate = plr.current_fire_rate
	count = plr.upgdata['overload']['shots']
	var mult = plr.upgdata['overload']['dmgmult']
	plr.current_bullet_dmg *= mult
	plr.current_fire_rate = 1.6
func prim():
	if count != 0:
		count -= 1
		if count <= 0:
			plr.current_bullet_dmg = dmg
			plr.current_fire_rate = rate
