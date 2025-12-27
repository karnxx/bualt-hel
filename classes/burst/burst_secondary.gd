extends Node

var charging := false
var timer := 0.0
var plr
var can_timer = false
func secondary_pressed(p):
	plr = p
	charging = true
	timer = 0.0
	can_timer = true

func secondary_released():
	if not charging:
		return
	fire()
	charging = false
	can_timer = false

func _process(delta):
	if can_timer:
		timer += delta

func fire():
	var ratio = clamp(timer / 1.0, 0.0, 1.0)
	var bulat = preload("res://plr/bulet.tscn").instantiate()
	bulat.global_position = plr.global_position
	var dir = (plr.get_global_mouse_position() - bulat.global_position).normalized()
	bulat.shoot(plr, dir)
