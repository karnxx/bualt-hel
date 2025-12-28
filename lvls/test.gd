extends Node2D

@onready var spawns = $spawns
@export var enemy_types: Array = [
	{"scene": preload("res://plr/walkers.tscn"), "chance": 0.8},
	{"scene": preload("res://plr/dumy.tscn"), "chance": 0.2}
]
@export var spawn_interval: float = 2.0
@export var max_enemies: int = 10
@export var enemies_per_spawn: int = 1

var _spawn_timer: Timer
var _enemies: Array[Node2D] = []

func _ready():
	_spawn_timer = Timer.new()
	_spawn_timer.wait_time = spawn_interval
	_spawn_timer.autostart = true
	_spawn_timer.one_shot = false
	_spawn_timer.connect("timeout", Callable(self, "_spawn_enemies"))
	add_child(_spawn_timer)

func _spawn_enemies():
	if _enemies.size() >= max_enemies:
		return
	for i in range(enemies_per_spawn):
		if _enemies.size() >= max_enemies:
			break
		if spawns.get_child_count() == 0:
			continue
		var enemy_scene = _choose_enemy_scene()
		var enemy_instance = enemy_scene.instantiate()
		var spawn_point = spawns.get_child(randi() % spawns.get_child_count()).global_position
		enemy_instance.position = spawn_point
		get_tree().current_scene.add_child(enemy_instance)
		_enemies.append(enemy_instance)
		enemy_instance.connect("tree_exited", Callable(self, "_on_enemy_removed"), [enemy_instance])

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

func _on_enemy_removed(enemy):
	_enemies.erase(enemy)
