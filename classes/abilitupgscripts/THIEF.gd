extends Node
var plr



func _process(delta: float) -> void:
	for i in get_tree().get_nodes_in_group('enemy'):
		i.connect('died', ondeth)
	plr = get_parent()
	print(plr)

func ondeth(enemy):
	plr.health += (enemy.maxhealth * 0.05)
	print('asd')
