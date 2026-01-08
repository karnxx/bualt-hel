extends CharacterBody2D

var kb_velocity := Vector2.ZERO
var kb_decay := 1600.0

var maxhealth := 40
var health := 40
var dmg := randi_range(1,5) * GameManager.global_enemy_dmg_scale
var xp_given := 0

const BULLET_FROM_ENEMY = preload("res://plr/bulet_fromenmy.tscn")

var plr
var can_shoot := true
var shoot_delay := 0.1

var elite := false
var miniboss := true

var phase := 1
var angle_offset := 0.0
var diagonal_timer := 0.0
var spiral_offset := 0.0

var current_bullet_dmg = 5
var current_bullet_spd = 400

signal died(who)

func _ready():
	plr = get_parent().get_node("plr")
	if miniboss:
		maxhealth *= 4
		shoot_delay = 0.01
		$Sprite2D.scale *= 2.2
		$CollisionShape2D.scale *= 2.5
		$Sprite2D.modulate = Color.DARK_RED
	health = maxhealth
	xp_given = randi_range(2 * maxhealth, 4 * maxhealth) * GameManager.global_loot_mult
	$Timer.start()

func get_dmged(dtmg):
	health -= dtmg
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = Color.WHITE
	GameManager.emit_signal("enemydmg", self)
	if miniboss:
		if phase == 1 and health <= maxhealth * 0.66:
			enter_phase_2()
		elif phase == 2 and health <= maxhealth * 0.33:
			enter_phase_3()
	if health <= 0:
		die()

func die():
	get_parent().enemy_died()
	plr.add_xp(xp_given)
	emit_signal("died", self)
	queue_free()

func _physics_process(delta):
	velocity = kb_velocity
	move_and_slide()
	kb_velocity = kb_velocity.move_toward(Vector2.ZERO, kb_decay * delta)
	if can_shoot:
		if miniboss:
			match phase:
				1:
					cross_rotating()
				2:
					cross_rotating()
					aimed_wave()
				3:
					cross_rotating()
					aimed_wave()
					spiral_shot()
		else:
			cross_basic()
	diagonal_timer += delta
	if miniboss and diagonal_timer >= 3.0:
		diagonal_burst()
		diagonal_timer = 0.0

func _on_area_2d_body_entered(body):
	if body.is_in_group("plr"):
		body.get_dmged(dmg)

func cross_basic():
	spawn_bullet(Vector2.RIGHT.rotated(angle_offset))
	spawn_bullet(Vector2.RIGHT.rotated(angle_offset + PI/2))

func cross_rotating():
	angle_offset += 0.04 * phase # faster with higher phases
	for i in range(6):
		spawn_bullet(Vector2.RIGHT.rotated(angle_offset + i * PI/3))
	can_shoot = false
	await get_tree().create_timer(shoot_delay).timeout
	can_shoot = true

func aimed_wave():
	var base_dir = (plr.global_position - global_position).normalized()
	for i in [-3,-2,-1,0,1,2,3]:
		spawn_bullet(base_dir.rotated(i * 0.2))

func spiral_shot():
	spiral_offset += 0.2
	for i in range(4):
		spawn_bullet(Vector2.RIGHT.rotated(spiral_offset + i * PI/2))

func diagonal_burst():
	for i in [-1,1]:
		for j in [-1,1]:
			spawn_bullet(Vector2(i,j).normalized())

func spawn_bullet(dir):
	var b = BULLET_FROM_ENEMY.instantiate()
	b.global_position = global_position
	get_parent().add_child(b)
	b.shoot(self, dir.normalized())

func enter_phase_2():
	phase = 2
	shoot_delay = 0.008
	$Sprite2D.modulate = Color.ORANGE

func enter_phase_3():
	phase = 3
	shoot_delay = 0.005
	$Sprite2D.modulate = Color.RED

func _on_timer_timeout():
	$Timer.start()

func knockback(pos, strength):
	var dir = (global_position - pos).normalized()
	kb_velocity += dir * strength
