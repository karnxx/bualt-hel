extends Node2D

@onready var shapeaea = $Area2D/CollisionShape2D

@export var base_spawn_delay := 1.8
@export var min_spawn_delay := 0.35
@export var spawn_radius_min := 500
@export var spawn_radius_max := 800

@export var max_enemies_on_screen := 120
@export var max_elites_on_screen := 8
@export var max_impact_enemies := 5

var enabled = true

var plr : Node2D
var spawn_timer := 0.0
var alive := 0
var elites_alive := 0
var impact_alive := 0

@export var enemy_types := [
	{"scene": preload("res://plr/walkers.tscn"),  "chance": 0.10, "unlock_lvl": 3,  "impact": false},
	{"scene": preload("res://plr/charger.tscn"),  "chance": 0.20, "unlock_lvl": 0,  "impact": true},
	{"scene": preload("res://plr/walkerbara.tscn"),  "chance": 0.20, "unlock_lvl": 0,  "impact": false},
	{"scene": preload("res://plr/righters.tscn"), "chance": 0.18, "unlock_lvl": 7,  "impact": false},
	{"scene": preload("res://plr/bombers.tscn"),  "chance": 0.10, "unlock_lvl": 10,  "impact": true},
	{"scene": preload("res://plr/splitter.tscn"), "chance": 0.10, "unlock_lvl": 12,  "impact": false},
	{"scene": preload("res://plr/wanderer.tscn"), "chance": 0.08, "unlock_lvl": 9, "impact": false},
	{"scene": preload("res://plr/twins.tscn"),    "chance": 0.07, "unlock_lvl": 12, "impact": false},
	{"scene": preload("res://plr/dumy.tscn"),     "chance": 0.07, "unlock_lvl": 12, "impact": true},
	{"scene": preload("res://plr/spreader.tscn"), "chance": 0.06, "unlock_lvl": 13, "impact": false},
	{"scene": preload("res://plr/stomper.tscn"), "chance": 0.06, "unlock_lvl": 2, "impact": false},
	{"scene": preload("res://plr/doublehsot.tscn"), "chance": 0.06, "unlock_lvl": 5, "impact": false},
	{"scene": preload("res://plr/cicrler.tscn"), "chance": 0.06, "unlock_lvl": 6, "impact": false},
]

var boss_scene = preload("res://plr/boss.tscn")

func _ready():
	plr = get_tree().current_scene.get_node("plr")
	spawn_timer = base_spawn_delay
	despawn_all()


func _process(delta):
	if not plr or not is_instance_valid(plr):
		return

	# ===== BOSS TRIGGER =====
	if plr.lvl >= 15 and enabled:
		enabled = false
		despawn_all()

		# prevent duplicate boss spawns
		for n in get_tree().current_scene.get_children():
			if n.scene_file_path == boss_scene.resource_path:
				return

		var boss = boss_scene.instantiate()
		boss.global_position = plr.global_position + Vector2(0, -600)
		get_tree().current_scene.add_child(boss)
		return
	# =======================

	if not enabled:
		spawn_timer = base_spawn_delay
		return

	spawn_timer -= delta

	if spawn_timer <= 0.0:
		if alive < max_enemies_on_screen:
			spawn_enemy()

		var delay := base_spawn_delay
		delay -= plr.lvl * 0.12
		delay *= 1.0 - clamp(float(alive) / max_enemies_on_screen, 0.0, 0.7)
		spawn_timer = max(min_spawn_delay, delay)


func despawn_all():
	for e in get_tree().get_nodes_in_group("enemies"):
		e.queue_free()

	alive = 0
	elites_alive = 0
	impact_alive = 0


func get_spawn_position() -> Vector2:
	var cam := get_viewport().get_camera_2d()
	var screen_rect := Rect2()
	if cam:
		screen_rect = Rect2(
			cam.global_position - get_viewport_rect().size * 0.5,
			get_viewport_rect().size
		)

	var dir := Vector2.RIGHT
	if plr.has_method("get_velocity"):
		var v = plr.get_velocity()
		if v.length() > 10:
			dir = v.normalized()

	var base_angle := dir.angle()

	for i in range(10):
		var angle = base_angle + randf_range(-PI * 0.8, PI * 0.8)
		var dist = randf_range(spawn_radius_min, spawn_radius_max)
		var pos = plr.global_position + Vector2.from_angle(angle) * dist

		if cam and screen_rect.has_point(pos):
			continue

		if is_too_close(pos):
			continue

		return pos

	return plr.global_position + Vector2.from_angle(randf() * TAU) * spawn_radius_max


func is_too_close(pos: Vector2) -> bool:
	for e in get_tree().get_nodes_in_group("enemies"):
		if e.global_position.distance_to(pos) < 120:
			return true
	return false


func spawn_enemy():
	var enemy_data = choose_enemy_data()
	if enemy_data == null:
		return

	var enemy = enemy_data.scene.instantiate()
	enemy.global_position = get_spawn_position()
	get_tree().current_scene.add_child(enemy)

	alive += 1

	var elite_chance = min(0.02 + plr.lvl * 0.01, 0.15)
	if randf() < elite_chance and elites_alive < max_elites_on_screen:
		enemy.elite = true
		elites_alive += 1

	if enemy_data.impact:
		impact_alive += 1
		enemy.set_meta("impact", true)

	if enemy.has_signal("died"):
		enemy.connect("died", Callable(self, "enemy_died"))


func enemy_died(enemy):
	alive -= 1

	if enemy.elite:
		elites_alive -= 1

	if enemy.has_meta("impact") and enemy.get_meta("impact"):
		impact_alive -= 1


func choose_enemy_data():
	var available := []

	for e in enemy_types:
		if plr.lvl < e.unlock_lvl:
			continue

		if e.impact and impact_alive >= max_impact_enemies:
			continue

		available.append(e)

	if available.is_empty():
		return null

	var total := 0.0
	for e in available:
		total += e.chance

	var roll := randf() * total
	var acc := 0.0

	for e in available:
		acc += e.chance
		if roll <= acc:
			return e

	return available[0]
