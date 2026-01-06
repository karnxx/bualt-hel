extends Node

var plr
@onready var bullet_scene := preload("res://plr/bulet.tscn")

func _ready() -> void:
	plr = get_parent()
	plr.fired.connect(firded)

func firded():
	var origin = plr.global_position
	var target = plr.passive.near_nemy(origin)
	if target == null:
		return
	
	for i in range(2):
		var bullet = bullet_scene.instantiate()
		bullet.global_position = origin
		plr.get_parent().add_child(bullet)
		bullet.homer = true
		bullet.target = target
		bullet.pierce = plr.pierce
		bullet.chunky = plr.chunky
		bullet.ricochet = plr.ricochet
		bullet.exploding = plr.exploding
		bullet.shoot(plr, Vector2.RIGHT, plr)
	print('asd')
