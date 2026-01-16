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
var bullet_hell_on_cd := false
var bullet_hell_active := false

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
	if health < phase2 and health > phase1:
		pass
	$ProgressBar.value = health
	if phase == phases.one:
		if !bullet_hell_active:
			spambeam()
		ranadtp()
		spawn_bombs()
	if phase == phases.two:
		if !bullet_hell_active:
			spambeam()
		ranadtp()
		spawn_bombs()
		sp_atk()

func spawn_walker():
	if can_spawn == false:
		return
	var walk = preload('res://plr/walkers.tscn').instantiate()
	can_spawn = false
	$timers/spawn.start()
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

func sp_atk():
	if bullet_hell_on_cd:
		return

	bullet_hell_on_cd = true
	bullet_hell_active = true

	area = get_parent().shapeaea
	var shape = area.shape
	var ext = shape.extents
	var center = area.global_position

	var spacing = 64
	var elapsed = 0
	var tick = 0

	while elapsed < 5:
		tp(get_random_position())

		var sides = [0, 1, 2, 3]
		sides.shuffle()
		var active = sides.slice(0, 2)

		var shift = (tick % 2) * (spacing * 0.5)

		for side in active:
			if side == 0 or side == 1:
				var count = int((ext.y * 2) / spacing) + 2
				for i in range(count):
					var bulart = bulat.instantiate()
					var asdy = center.y - ext.y + i * spacing + shift

					if side == 0:
						bulart.global_position = Vector2(center.x - ext.x,asdy)
						bulart.shoot(self, Vector2(1, 0))
					else:
						bulart.global_position = Vector2(center.x + ext.x, asdy)
						bulart.shoot(self, Vector2(-1, 0))

					get_parent().add_child(bulart)
			else:
				var count = int((ext.x * 2) / spacing) + 2
				for i in range(count):
					var bulart = bulat.instantiate()
					var asdx = center.x - ext.x + i * spacing + shift

					if side == 2:
						bulart.global_position = Vector2(asdx, center.y - ext.y)
						bulart.shoot(self, Vector2(0, 1))
					else:
						bulart.global_position = Vector2(asdx, center.y + ext.y)
						bulart.shoot(self, Vector2(0, -1))

					get_parent().add_child(bulart)

		await get_tree().create_timer(1).timeout
		elapsed += 1
		tick += 1

	bullet_hell_active = false
	await get_tree().create_timer(10).timeout
	bullet_hell_on_cd = false


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

func _on_spawn_timeout() -> void:
	can_spawn = true
