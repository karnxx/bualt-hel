extends Node

var plr
var shot_count := 0

const BLOOM_BULLETS := 3
const SPREAD_DEG := 120

func _ready():
	plr.primscript.connect("fired", fired)

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
		
		var b = plr.bulet.instantiate()
		plr.get_parent().add_child(b)
		b.global_position = plr.global_position
		b.plr = plr
		b.velocity = Vector2.RIGHT.rotated(angle) * plr.current_bullet_spd
		b.dmg = plr.current_bullet_dmg
		
	plr.current_bullets -= 3
