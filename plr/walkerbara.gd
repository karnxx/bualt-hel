extends CharacterBody2D

var kb_velocity: Vector2 = Vector2.ZERO
var kb_strength := 420.0
var kb_decay := 1600.0

var maxhealth = 5
var health = 5
var xp_given = randi_range(2 * health, 4 * health) / 3 * GameManager.global_loot_mult
var dmg = 1 * GameManager.global_enemy_dmg_scale

const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")

var plr
var current_bullet_dmg = 1 * GameManager.global_enemy_dmg_scale
var current_bullet_spd = 220.0

var spd = 180
var pathfind = true
var elite = false

var shoot_cd = 1.5
var can_shoot = true

var chip = true
signal died(who)

func _ready() -> void:
	plr = get_parent().get_node("plr")

func _physics_process(delta: float) -> void:
	if pathfind:
		move_to_player()

	velocity += kb_velocity
	move_and_slide()
	kb_velocity = kb_velocity.move_toward(Vector2.ZERO, kb_decay * delta)

	try_shoot()

func move_to_player():
	if not plr:
		return

	var dir = (plr.global_position - global_position).normalized()
	velocity = dir * spd * GameManager.time_scale

func try_shoot():
	if not can_shoot or not plr:
		return

	var dist = global_position.distance_to(plr.global_position)
	if dist > 300:
		return

	shoot()

func shoot():
	can_shoot = false
	pathfind = false
	velocity = Vector2.ZERO

	$Sprite2D.modulate = Color.YELLOW
	await get_tree().create_timer(0.5).timeout
	$Sprite2D.modulate = Color.WHITE

	if not is_instance_valid(plr):
		return

	var bullet = BULET_FROMENMY.instantiate()
	bullet.global_position = global_position

	var dir = (plr.global_position - global_position).normalized()
	get_parent().add_child(bullet)
	bullet.shoot(self, dir)
	await get_tree().create_timer(shoot_cd).timeout
	can_shoot = true
	pathfind = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("plr"):
		body.get_dmged(dmg)

func get_dmged(dtmg):
	health -= dtmg
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.15).timeout
	$Sprite2D.modulate = Color.WHITE

	GameManager.emit_signal('enemydmg', self)

	if health <= 0:
		get_parent().enemy_died(self)
		get_parent().get_node("plr").add_xp(xp_given)
		emit_signal("died", self)
		queue_free()

func knockback(from_pos, strength):
	var dir = (global_position - from_pos).normalized()
	kb_velocity += dir * strength
