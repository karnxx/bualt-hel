extends Node
var plr

func _ready() -> void:
	plr = get_parent()
	print(plr)

func _process(_delta: float) -> void:
	for i in get_tree().get_nodes_in_group('enemy'):
		if i.is_connected('died', ondeth):
			return
		i.connect('died', ondeth)

func ondeth(enemy):
	plr.current_bullets += 1
