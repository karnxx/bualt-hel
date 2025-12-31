extends Node2D

@onready var spawns = $spawns
@onready var label = $label

@export var enemy_types: Array = [
	{"scene": preload("res://plr/walkers.tscn"), "chance": 0.2},
	{"scene": preload("res://plr/dumy.tscn"), "chance": 0.3},
	{"scene": preload("res://plr/spreader.tscn"), "chance": 0.15},
	{"scene": preload("res://plr/wanderer.tscn"), "chance": 0.15},
	{"scene": preload("res://plr/righters.tscn"), "chance": 0.2}
]

@export var base_enemies := 1
@export var rounds := 5
var timer := 2.0
var alive := 0

func _ready():
	await get_tree().create_timer(3).timeout
	for r in range(rounds):
		await run_round(r + 1)
		get_node('plr').health += get_node('plr').max_health * 0.3
	label.text = "demo finished! nice try!"

func run_round(round_num):
	var total_enemies = (base_enemies + round_num * 3)
	label.text = "round:" + str(round_num)

	for i in range(total_enemies):
		if spawns.get_child_count() == 0:
			break
		
		var enemy_scene = _choose_enemy_scene()
		var enemy = enemy_scene.instantiate()
		var spawn_point = spawns.get_child(
			randi() % spawns.get_child_count()
		).global_position
		
		enemy.global_position = spawn_point
		if is_inside_tree():
			get_tree().current_scene.add_child(enemy)
		alive += 1
		var rand = randf()
		if rand <= 0.05:
			enemy.elite = true
		if is_inside_tree():
			await get_tree().create_timer(timer).timeout
	while alive > 0 and is_inside_tree():
		await get_tree().process_frame


func enemy_died():
	alive -= 1

func _choose_enemy_scene() -> PackedScene:
	var total = 0.0
	for e in enemy_types:
		total += e["chance"]

	var roll = randf() * total
	var cumulative = 0.0

	for e in enemy_types:
		cumulative += e["chance"]
		if roll <= cumulative:
			return e["scene"]

	return enemy_types[0]["scene"]
