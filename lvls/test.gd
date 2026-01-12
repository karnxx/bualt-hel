extends Node2D

@export var base_spawn_delay := 1.8
@export var min_spawn_delay := 0.35
@export var spawn_radius_min := 500
@export var spawn_radius_max := 800

@export var max_enemies_on_screen := 120
@export var max_elites_on_screen := 8
@export var max_impact_enemies := 5

var plr : Node2D
var spawn_timer := 0.0
var alive := 0
var elites_alive := 0
var impact_alive := 0

@export var enemy_types := [
	{"scene": preload("res://plr/walkers.tscn"),  "chance": 0.10, "unlock_lvl": 3,  "impact": false},
	{"scene": preload("res://plr/charger.tscn"),  "chance": 0.20, "unlock_lvl": 0,  "impact": true},
	{"scene": preload("res://plr/walkerbara.tscn"),  "chance": 0.20, "unlock_lvl": 0,  "impact": false},
	{"scene": preload("res://plr/righters.tscn"), "chance": 0.18, "unlock_lvl": 5,  "impact": false},
	{"scene": preload("res://plr/bombers.tscn"),  "chance": 0.10, "unlock_lvl": 7,  "impact": true},
	{"scene": preload("res://plr/splitter.tscn"), "chance": 0.10, "unlock_lvl": 7,  "impact": false},
	{"scene": preload("res://plr/wanderer.tscn"), "chance": 0.08, "unlock_lvl": 9, "impact": false},
	{"scene": preload("res://plr/twins.tscn"),    "chance": 0.07, "unlock_lvl": 10, "impact": false},
	{"scene": preload("res://plr/dumy.tscn"),     "chance": 0.07, "unlock_lvl": 12, "impact": true},
	{"scene": preload("res://plr/spreader.tscn"), "chance": 0.06, "unlock_lvl": 13, "impact": false},
	{"scene": preload("res://plr/stomper.tscn"), "chance": 0.06, "unlock_lvl": 2, "impact": false},
]


func _ready():
	plr = get_tree().current_scene.get_node("plr")
	spawn_timer = base_spawn_delay

func _process(delta):
	if not plr or not is_instance_valid(plr):
		return

	spawn_timer -= delta

	if spawn_timer <= 0.0:
		if alive < max_enemies_on_screen:
			spawn_enemy()

		var delay := base_spawn_delay
		delay -= plr.lvl * 0.12
		delay *= 1.0 - clamp(float(alive) / max_enemies_on_screen, 0.0, 0.7)
		spawn_timer = max(min_spawn_delay, delay)


func spawn_enemy():
	var enemy_data = choose_enemy_data()
	if enemy_data == null:
		return

	var enemy = enemy_data.scene.instantiate()

	var angle = randf() * TAU
	var dist = spawn_radius_min + pow(randf(), 1.5) * (spawn_radius_max - spawn_radius_min)
	enemy.global_position = plr.global_position + Vector2(cos(angle), sin(angle)) * dist

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
