extends Node2D

@onready var spawns = $spawns
@export var enemy_types: Array = [
	{"scene": preload("res://plr/walkers.tscn"), "chance": 0.8},
	{"scene": preload("res://plr/dumy.tscn"), "chance": 0.2}
]
@export var total_enemies: int = 20
var timer = 2
func _ready():
	await get_tree().create_timer(5).timeout
	for i in range(total_enemies):
		if spawns.get_child_count() == 0:
			break
		var enemy_scene = _choose_enemy_scene()
		var enemy_instance = enemy_scene.instantiate()
		var spawn_point = spawns.get_child(randi() % spawns.get_child_count()).global_position
		enemy_instance.position = spawn_point
		get_tree().current_scene.add_child(enemy_instance)
		await get_tree().create_timer(timer).timeout

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
