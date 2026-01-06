extends Node

var plr
@onready var bullet_scene := preload("res://plr/bulet.tscn")

var current_bullet_spd := 150
var current_bullet_dmg := 2

func _ready() -> void:
	plr = get_parent()
	if not plr.fired.is_connected(firded):
		plr.fired.connect(firded)

func firded():
	var origin = plr.global_position
	var target = plr.passive.near_nemy(origin)
	if target == null:
		return

	var count := 2
	var spread := deg_to_rad(10.0)
	var spawn_sep := 6.0
	var kick_strength := 120.0

	var forward = (plr.get_global_mouse_position() - origin).normalized()

	var side := Vector2(-forward.y, forward.x)

	for i in range(count):
		var bullet = bullet_scene.instantiate()

		var t := i - (count - 1) * 0.5

		bullet.global_position = origin + side * spawn_sep * t
		bullet.get_node("Sprite2D").scale *= 0.5
		bullet.get_node("CollisionShape2D").scale *= 0.5

		plr.get_parent().add_child(bullet)
		var dir = forward.rotated(spread * t)
		bullet.homer = true
		bullet.target = target
		bullet.pierce = plr.pierce
		bullet.chunky = plr.chunky
		bullet.ricochet = plr.ricochet
		bullet.exploding = plr.exploding
		bullet.homing_delay = 0.08
		bullet.homing_timer = 0.0 
		bullet.shoot(self, dir, plr)
		bullet.velocity += side * kick_strength * t
