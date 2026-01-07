extends Node
var plr
func _ready() -> void:
	plr = get_parent()
	GameManager.connect("bulletstarted", asd)

func asd(who: CharacterBody2D):
	await get_tree().create_timer(0.1).timeout
	if is_instance_valid(who):
		who.spd = 100
	
	while is_instance_valid(who):
		print('asd')
		who.spd += 1
		await get_tree().create_timer(0.05).timeout
