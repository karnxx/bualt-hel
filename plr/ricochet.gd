extends CharacterBody2D

var dmg
var pierce = 0
var homer = false
var turn_rate := deg_to_rad(90)
var spd
var target : Node2D = null
var crit
var critdmg
var plr

var bounces := 1
var spd_dec := 2.0


func _ready() -> void:
	await get_tree().create_timer(5).timeout
	queue_free()

func shoot(pglr, dir, plar):
	dmg = pglr.current_bullet_dmg
	spd = pglr.current_bullet_spd
	plr = plar
	velocity = dir.normalized() * spd
	rotation = dir.angle()
	crit = plr.crit
	critdmg = plr.critmult
	bounces = plr.upgdata['ricochet']['bounces']
	spd_dec = plr.upgdata['ricochet']['spd_dec']

func _physics_process(delta):

	if homer and target and is_instance_valid(target):
		var desired_dir = (target.global_position - global_position).normalized()
		var current_dir = velocity.normalized()
		var angle_diff = current_dir.angle_to(desired_dir)
		var max_turn = turn_rate * delta
		var turn = clamp(angle_diff, -max_turn, max_turn)
		current_dir = current_dir.rotated(turn)
		velocity = current_dir * spd
		rotation = current_dir.angle()

	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.get_collider()

		if body.has_method("get_dmged") and body.is_in_group("enemy"):
			if randf() <= crit:
				body.get_dmged(dmg * critdmg)
			else:
				body.get_dmged(dmg)

			if pierce > 0:
				pierce -= 1
			else:
				queue_free()
				return

		if bounces > 0:
			var normal = collision.get_normal()
			velocity = velocity - 2 * velocity.dot(normal) * normal
			velocity /= spd_dec
			bounces -= 1
		else:
			queue_free()
