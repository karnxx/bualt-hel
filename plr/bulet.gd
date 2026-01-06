extends CharacterBody2D

# --- Bullet Settings ---
var dmg
var pierce = 0
var spd
var crit
var critdmg
var plr

# --- Behavior Flags ---
var homer := false
var chunky := false
var ricochet := false
var exploding = false

# --- Homing ---
var target: Node2D = null
var turn_rate := deg_to_rad(70)

# --- Chunky ---
const BULLET = preload("res://plr/bulet.tscn")
var split_count := 2
var split_angle := 30
var can_split := true
var dmg_mult := 4

# --- Ricochet ---
var bounces := 0
var spd_dec := 2.0

func _ready() -> void:
	plr = get_parent().get_node('plr')
	await get_tree().create_timer(5).timeout
	GameManager.emit_signal("bullettimeout", self)
	queue_free()

func shoot(pglr, dir, plar):
	# Base stats
	dmg = pglr.current_bullet_dmg
	spd = pglr.current_bullet_spd
	plr = plar
	velocity = dir.normalized() * spd
	rotation = dir.angle()
	crit = plr.crit
	critdmg = plr.critmult

	if chunky:
		dmg_mult = plar.upgdata['chunky']['chunkmult']
		split_count = plar.upgdata['chunky']['chunks']

	if ricochet:
		bounces = plar.upgdata['ricochet']['bounces']
		spd_dec = plar.upgdata['ricochet']['spd_dec']

func split():
	if not can_split:
		return
	can_split = false

	var base_dir = velocity.normalized()
	var angle_step = deg_to_rad(split_angle)

	for i in range(split_count):
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = global_position

		var offset = i - (split_count - 1) / 2.0
		var new_dir = base_dir.rotated(angle_step * offset)
		new_bullet.dmg = round(dmg / dmg_mult)
		new_bullet.velocity = new_dir * velocity.length()
		new_bullet.rotation = new_dir.angle()
		new_bullet.pierce = 0
		new_bullet.scale = scale * 0.5

		get_tree().current_scene.add_child(new_bullet)

func _on_area_2d_body_entered(body: Node2D) -> void:
	plr = get_parent().get_node('plr')
	crit = plr.crit
	critdmg = plr.critmult

	if body.has_method('get_dmged') and body.is_in_group('enemy'):
		var damage_to_deal = dmg
		if randf() <= crit:
			damage_to_deal *= critdmg
		body.get_dmged(damage_to_deal)

		if chunky:
			call_deferred("split")

		if pierce > 0:
			pierce -= 1
		else:
			if exploding:
				var explsion = preload("res://plr/explode.tscn").instantiate()
				explsion.global_position = global_position
				get_parent().add_child(explsion)
			call_deferred("queue_free")


func _physics_process(delta):
	if homer and target and is_instance_valid(target):
		turn_rate = plr.upgdata['seek']['seekpower']
		
		var desired_dir = (target.global_position - global_position).normalized()
		var current_dir = velocity.normalized()
		var angle_diff = current_dir.angle_to(desired_dir)
		var max_turn = turn_rate * delta
		var turn = clamp(angle_diff, -max_turn, max_turn)
		current_dir = current_dir.rotated(turn)
		velocity = current_dir * spd
		rotation = current_dir.angle()

	if ricochet:
		var collision = move_and_collide(velocity * delta)
		if collision:
			var body = collision.get_collider()
			# Damage enemies
			if body.has_method("get_dmged") and body.is_in_group("enemy"):
				var dmg_to_do = dmg
				if randf() <= crit:
					dmg_to_do *= critdmg
				body.get_dmged(dmg_to_do)

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
	else:
		move_and_slide()
