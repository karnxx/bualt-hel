extends Node
var plr
func _ready() -> void:
	plr = get_parent()
	GameManager.connect("enemydmg", friarr)

func friarr(who):
	var spd = who.spd
	var buletspd = who.current_bullet_spd
	who.spd *= 0.3
	who.current_bullet_spd *= 0.3
	await get_tree().create_timer(2).timeout
	if is_instance_valid(who):
		who.spd = spd
		who.current_bullet_spd = buletspd
