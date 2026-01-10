extends CharacterBody2D

var dmg
var pierce := 0
var lifetime := 0.0
const MAX_LIFE := 4.0

func shoot(plr, dir):
	dmg = plr.current_bullet_dmg
	var spd = plr.current_bullet_spd
	velocity = dir.normalized() * spd * GameManager.time_scale
	rotation = velocity.angle()
	lifetime = 0

func _physics_process(delta):
	lifetime += delta
	if lifetime >= MAX_LIFE:
		queue_free()
		return
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("plr") and body.has_method("get_dmged"):
		body.get_dmged(dmg)
		if pierce > 0:
			pierce -= 1
		else:
			queue_free()
