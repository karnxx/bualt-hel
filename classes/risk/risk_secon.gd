extends Node

var plr
var bullets = []
var radius = 80.0
var angle = 0.0
var duration = 5.0
var time = 0.0

func secondary(p):
	plr = p
	time = 0.0
	angle = 0.0
	bullets.clear()

	var count = 8
	for i in range(count):
		var b = preload("res://plr/bulet.tscn").instantiate()
		plr.get_parent().add_child(b)
		bullets.append(b)

	set_process(true)

func _process(delta):
	time += delta
	if time >= duration:
		end()
		return

	angle += delta * 4.0

	for i in range(bullets.size()):
		var a = angle + (TAU * i / bullets.size())
		var offset = Vector2(cos(a), sin(a)) * radius
		bullets[i].global_position = plr.global_position + offset

func end():
	for b in bullets:
		b.queue_free()
	bullets.clear()
	set_process(false)
