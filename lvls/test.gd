extends Node2D

@export var base_spawn_delay := 1.8
@export var min_spawn_delay := 0.25
@export var spawn_radius_min := 500
@export var spawn_radius_max := 800
@export var max_enemies_on_screen := 120
@export var max_elites_on_screen := 8

var player : Node2D
var spawn_timer := 0.0
var elapsed_time := 0.0
var alive := 0
var elites_alive := 0

@export var enemy_types := [
	{"scene": preload("res://plr/cicrler.tscn"), "chance": 0.08, "unlock_time": 120},
	{"scene": preload("res://plr/walkers.tscn"), "chance": 0.18, "unlock_time": 0},
	{"scene": preload("res://plr/charger.tscn"), "chance": 0.2, "unlock_time": 10},
	{"scene": preload("res://plr/righters.tscn"), "chance": 0.2, "unlock_time": 60},
	{"scene": preload("res://plr/bombers.tscn"), "chance": 0.10, "unlock_time": 150},
	{"scene": preload("res://plr/splitter.tscn"), "chance": 0.10, "unlock_time": 180},
	{"scene": preload("res://plr/wanderer.tscn"), "chance": 0.10, "unlock_time": 240},
	{"scene": preload("res://plr/twins.tscn"), "chance": 0.08, "unlock_time": 300},
	{"scene": preload("res://plr/dumy.tscn"), "chance": 0.08, "unlock_time": 360},
	{"scene": preload("res://plr/spreader.tscn"), "chance": 0.08, "unlock_time": 450},
]

func _ready():
	player = get_tree().current_scene.get_node("plr")
	spawn_timer = base_spawn_delay

func _process(delta):
	if not player or not is_instance_valid(player):
		return
	elapsed_time += delta
	spawn_timer -= delta
	if spawn_timer <= 0:
		if alive < max_enemies_on_screen:
			spawn_enemy()
		var delay = base_spawn_delay - elapsed_time * 0.01
		delay *= 1.0 - clamp(float(alive)/max_enemies_on_screen, 0.0, 0.8)
		spawn_timer = max(min_spawn_delay, delay)

func spawn_enemy():
	var enemy_scene = choose_enemy_scene()
	var enemy = enemy_scene.instantiate()

	var angle = randf() * TAU
	var distance = spawn_radius_min + pow(randf(), 1.5) * (spawn_radius_max - spawn_radius_min)
	enemy.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * distance

	get_tree().current_scene.add_child(enemy)
	alive += 1

	var elite_chance = min(0.03 + elapsed_time * 0.001, 0.12)
	if randf() < elite_chance and elites_alive < max_elites_on_screen:
		enemy.elite = true
		elites_alive += 1

	if enemy.has_signal("died"):
		enemy.connect("died", Callable(self, "enemy_died"))

func enemy_died(enemy_node=null):
	alive -= 1
	if enemy_node and enemy_node.elite:
		elites_alive -= 1

func choose_enemy_scene() -> PackedScene:
	var available := []
	for e in enemy_types:
		if elapsed_time >= e["unlock_time"]:
			available.append(e)
	if available.size() == 0:
		return enemy_types[0]["scene"]
	var total = 0.0
	for e in available:
		total += e["chance"] * (1 + elapsed_time * 0.0005)
	var roll = randf() * total
	var acc = 0.0
	for e in available:
		acc += e["chance"] * (1 + elapsed_time * 0.0005)
		if roll <= acc:
			return e["scene"]
	return available[0]["scene"]
