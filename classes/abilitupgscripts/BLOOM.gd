extends Node

var plr
var shot_count := 0
const BLOOM_BULLETS := 3
const ANGLE_STEP := TAU / BLOOM_BULLETS

func _ready():
	# hook into shooting via signal or method wrapping
	plr.primscript.connect("shot_fired", _on_shot_fired)

func _on_shot_fired():
	shot_count += 1
	if shot_count % 3 == 0:
		fire_bloom()

func fire_bloom():
	for i in BLOOM_BULLETS:
		var b = plr.bulet.instantiate()
		plr.get_parent().add_child(b)
		b.global_position = plr.global_position

		var angle = i * ANGLE_STEP
		b.velocity = Vector2.RIGHT.rotated(angle) * plr.current_bullet_spd
		b.damage = plr.current_bullet_dmg
