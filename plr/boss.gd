extends CharacterBody2D

var health = 2500
var phase1 = 800
var phase2 = 1800
var plr
var bulat = preload("res://plr/bulet_fromenmy.tscn")
var current_bullet_dmg = 5
var current_bullet_spd = 1500
var area
enum phases {one,two,three} #[1,2,3]
var phase

var can_tp = false

func _ready() -> void:
	phase_1()

func _process(delta: float) -> void:
	if phase == phases.one:
		spambeam()

func phase_1():
	var plar = get_parent().get_node('plr')
	plr = plar
	phase = phases.one
	$timers/Timer.wait_time = 4
	$Icon.modulate = Color(1, 0.6, 0.6)
	await get_tree().create_timer(0.3).timeout
	$Icon.modulate = Color.WHITE

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
		$timers/Timer.start()

func tp(pos):
	global_position = pos

func get_random_position() -> Vector2:
	var rect = area.size
	var random_x = randf_range(-rect.x / 2, rect.x / 2)
	var random_y = randf_range(-rect.y / 2, rect.y / 2)
	return global_position + Vector2(random_x, random_y)
