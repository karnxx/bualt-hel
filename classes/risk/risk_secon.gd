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
	plr.health = round(plr.health * 0.5)
	plr.current_bullets = plr.magazine
	var count = 8
	for i in range(count):
		var b = plr.bulet.instantiate()
		plr.get_parent().add_child(b)
		b.dmg = plr.current_bullet_dmg
		b.plr = plr
		bullets.append(b)

	set_process(true)
	

func _process(delta):
	if bullets.is_empty():
		return

	time += delta
	if time >= duration:
		end()
		return

	angle += delta * 4.0

	for i in range(bullets.size()):
		var b = bullets[i]
		if not is_instance_valid(b):
			continue

		var a = angle + (TAU * i / bullets.size())
		var offset = Vector2(cos(a), sin(a)) * radius
		b.global_position = plr.global_position + offset

func end():
	set_process(false)
	for b in bullets:
		if is_instance_valid(b):
			b.queue_free()
	get_tree().create_timer(10).timeout.connect(dnoe)
	bullets.clear()

func dnoe():
	plr.can_secondary = true
