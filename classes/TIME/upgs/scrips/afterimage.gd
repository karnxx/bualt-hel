extends Node
var plr
func _ready() -> void:
	plr = get_parent()
	GameManager.connect("bulletstarted", asd)

func asd(who: CharacterBody2D):
	while is_instance_valid(who):
		var bulet = preload("res://plr/bulet.tscn").instantiate()
		bulet.global_position = who.global_position
		bulet.dmg = 2
		bulet.get_node('CollisionShape2D').scale /= 2
		bulet.get_node('Sprite2D').scale /= 2
		get_parent().get_parent().add_child(bulet)
		await get_tree().create_timer(0.1).timeout
