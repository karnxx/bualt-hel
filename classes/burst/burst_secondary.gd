extends Node

const MAX_CHARGE := 2.0

var charging := false
var timer := 0.0
var plr
var can_timer := false

var current_bullet_dmg
var current_bullet_spd

func secondary_pressed(p):
	if charging:
		return
	plr = p
	charging = true
	can_timer = true
	current_bullet_dmg = plr.current_bullet_dmg
	current_bullet_spd = plr.current_bullet_spd

func secondary_released():
	if not charging:
		return
	release()

func _process(delta):
	if not can_timer:
		return
	timer += delta
	if timer >= MAX_CHARGE:
		release()

func release():
	fire()
	charging = false
	can_timer = false
	timer = 0.0

func fire():
	var ratio = clamp(timer / MAX_CHARGE, 0.0, 1.0)

	var bulat = preload("res://plr/bulet.tscn").instantiate()
	bulat.global_position = plr.global_position
	var dir = (plr.get_global_mouse_position() - bulat.global_position).normalized()
	plr.get_parent().add_child(bulat)

	var s = lerp(1.0, 4.0, ratio)
	print(s)
	bulat.get_node("Sprite2D").scale = Vector2.ONE * s

	current_bullet_dmg = current_bullet_dmg + current_bullet_dmg * lerp(0.0, 2.0, ratio)
	bulat.shoot(self, dir)

	plr.current_bullets -= 1
