extends Node

var stack := 0
var pendingbul := 0
var plr
var dmg

func _ready() -> void:
	plr = get_parent()
	plr.connect('fired', fired)
	GameManager.connect('enemydmg', bullet_hit)
	GameManager.connect('bullettimeout', bullet_missed)


func fired():
	pendingbul += 1
	
func bullet_hit(_who):
	stack += 1
	pendingbul -= 1
	print('CURRENT STACK', str(stack))
	if stack == 0:
		dmg = plr.current_bullet_dmg
		plr.current_bullet_dmg =  dmg
	elif stack > 0:
		for i in range(stack):
			plr.current_bullet_dmg += 2

func bullet_missed(_bullet):
	stack = 0
	pendingbul -= 1
