extends Node
var plr
func _ready() -> void:
	plr = get_parent()

func _process(_delta: float) -> void:
	for i in get_tree().get_nodes_in_group('enemy'):
		if i.is_connected('died', ondeth):
			return
		i.connect('died', ondeth)

func ondeth(w):
	var explosion = preload("res://plr/explode.tscn").instantiate()
	explosion.global_position = w.global_position
	plr.get_parent().add_child(explosion)
