extends Node
var plr

func _ready() -> void:
	plr = get_parent()
	GameManager.connect('enemydmg', ondeth)

func ondeth(_enemy):
	plr.health += 3
