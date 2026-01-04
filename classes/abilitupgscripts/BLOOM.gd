extends Node

var plr
var shot_count := 0

var BLOOM_BULLETS := 3
var SPREAD_DEG := 120

func _ready():
	plr = get_parent()
	plr.primscript.connect("fired", fired)

func _process(_delta: float) -> void:
	BLOOM_BULLETS = plr.upgdata['bloom']['bloombul']
	SPREAD_DEG = plr.upgdata['bloom']['bloomfan']

func fired():
	shot_count += 1
	if shot_count % 3 == 0:
		fire_bloom()

func fire_bloom():
	var mouse_dir = (plr.get_global_mouse_position() - plr.global_position).normalized()
	var base_angle = mouse_dir.angle()

	var spread_rad := deg_to_rad(SPREAD_DEG)
	var step := spread_rad / (BLOOM_BULLETS - 1)
	var start := -spread_rad / 2

	for i in BLOOM_BULLETS:
		var angle = base_angle + start + step * i
		
		var bulat = plr.bulet.instantiate()
		plr.get_parent().add_child(bulat)
		bulat.global_position = plr.get_node('pivot/gun/origin').global_position
		bulat.homer = plr.homing
		bulat.chunky = plr.chunky
		bulat.ricochet = plr.ricochet
		bulat.exploding = plr.exploding
		bulat.plr = plr
		bulat.velocity = Vector2.RIGHT.rotated(angle) * plr.current_bullet_spd
		bulat.dmg = plr.current_bullet_dmg
		
	plr.current_bullets -= 3
