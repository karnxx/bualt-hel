extends CharacterBody2D

var health = 2500
var maxhp = 2500
var phase1 = 800
var phase2 = 1800
var plr
var bulat = preload("res://plr/bulet_fromenmy.tscn")
var current_bullet_dmg = 1
var current_bullet_spd = 800
var area
enum phases {one,two,three}
var phase

var kb_velocity = 0

var can_tp = false

var bombamt = 10
var canbomb = true
var bombint = 2
var can_spawn = false

func _ready() -> void:
	$ProgressBar.value = health
	$ProgressBar.max_value = maxhp
	phase_1()

func get_dmged(dtmg):
	health -= dtmg
	$Icon.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	$Icon.modulate = Color.WHITE

	if health <= 0:
		get_parent().enemy_died(self)
		get_parent().get_node("plr").add_xp(10)
		emit_signal("died", self)
		queue_free()

func knockback(pos, _strength):
	var _dir = (global_position - pos).normalized()
	kb_velocity += 1

func _process(_delta: float) -> void:
	$ProgressBar.value = health
	if phase == phases.one:
		spambeam()
		ranadtp()
		spawn_bombs()
		if phase == phases.two:
			pass

func spawn_walker():
	var walk = preload('res://plr/walkers.tscn').instantiate()
	walk.global_position = get_random_position()
	get_parent().add_child(walk)

func phase_1():
	var plar = get_parent().get_node('plr')
	plr = plar
	phase = phases.one
	$timers/Timer.wait_time = 8
	$timers/dettime.wait_time = 3
	$Icon.modulate = Color(1, 0.6, 0.6)
	await get_tree().create_timer(0.3).timeout
	$Icon.modulate = Color.WHITE

func phase_2():
	var plar = get_parent().get_node('plr')
	plr = plar
	phase = phases.two
	$timers/Timer.wait_time = 6
	$timers/dettime.wait_time = 2
	$Icon.modulate = Color(1, 0.6, 0.6)
	await get_tree().create_timer(0.3).timeout
	$Icon.modulate = Color.WHITE
	can_spawn = true

func spambeam():
	var buala = bulat.instantiate()
	var dir = (plr.global_position - global_position).normalized()
	buala.global_position = global_position
	get_parent().add_child(buala)
	buala.shoot(self, dir)

func ranadtp():
	if can_tp:
		area = get_parent().shapeaea
		tp(get_random_position())
		can_tp = false

func tp(pos):
	global_position = pos

func spawn_bombs():
	if !canbomb:
		return
	if area == null:
		area = get_parent().shapeaea
	for i in range(bombint):
		var pos = get_random_position()
		fire_circle(pos)
	canbomb = false
	$timers/bomb.start()

func fire_circle(origin):
	for i in range(4):
		$Icon.modulate = Color.YELLOW
		await get_tree().create_timer(0.2).timeout
		$Icon.modulate = Color.WHITE
		await get_tree().create_timer(0.2).timeout
	for i in range(bombamt):
		var angle = TAU * i / bombamt
		var dir = Vector2(cos(angle), sin(angle))
		var bulaty = bulat.instantiate()
		bulaty.global_position = origin
		get_parent().add_child(bulaty)
		bulaty.shoot(self, dir)

func get_random_position():
	var shape = area.shape
	var extents = shape.extents
	var center = area.global_position

	return Vector2(
		randf_range(center.x - extents.x, center.x + extents.x),
		randf_range(center.y - extents.y, center.y + extents.y)
	)


func _on_timer_timeout() -> void:
	can_tp = true
	ranadtp()

func _on_tpdet_body_entered(body: Node2D) -> void:
	if body.is_in_group('plr'):
		$timers/dettime.start()

func _on_dettime_timeout() -> void:
	can_tp = true
	ranadtp()

func _on_bomb_timeout() -> void:
	canbomb = true
