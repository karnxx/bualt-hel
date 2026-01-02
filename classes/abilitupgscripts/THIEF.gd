extends Node
var plr

func _process(_delta: float) -> void:
	for i in get_tree().get_nodes_in_group('enemy'):
		if i.is_connected('deth', ondeth):
			return
		i.connect('died', ondeth)
	plr = get_parent()

func ondeth(enemy):
	plr.health += (enemy.maxhealth * 0.05)
	print('asd')
