extends CharacterBody2D

var kb_velocity: Vector2 = Vector2.ZERO
var kb_strength := 420.0
var kb_decay := 1600.0

var maxhealth = 20
var health = 2
var xp_given = randi_range(2 * health, 4 * health)/3 * GameManager.global_loot_mult
var dmg = randi_range(1,5) * GameManager.global_enemy_dmg_scale
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr
var current_bullet_dmg = 5 * GameManager.global_enemy_dmg_scale
var current_bullet_spd = GameManager.global_enemy_bullet_spd

var spd = 120
var pathfind = true
var elite = false
var cd = 1.0
var canshot = true
var chip = true
signal died(who)

func _ready() -> void:
	plr = get_parent().get_node("plr")
	if elite:
		$Sprite2D.scale *= 2
		$Sprite2D.modulate = Color.WEB_PURPLE
		$CollisionShape2D.scale *= 2
		spd = 800
		cd = 0.6
		health /= 2

func _physics_process(delta: float) -> void:
	if pathfind:
		move_to_player()
	velocity += kb_velocity
	move_and_slide()
	kb_velocity = kb_velocity.move_toward(Vector2.ZERO, kb_decay * delta)

func move_to_player():
	if not plr:
		return
	var target = plr.global_position
	var dir = (target - global_position).normalized()
	velocity = dir * spd * GameManager.time_scale

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("plr"):
		body.get_dmged(dmg)
		pathfind = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("plr"):
		await get_tree().create_timer(cd).timeout
		pathfind = true

func get_dmged(dtmg):
	health -= dtmg
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.modulate = Color.WHITE
	GameManager.emit_signal('enemydmg', self)
	if health <= 0:
		xp_given =randi_range(2 * maxhealth, 4 * maxhealth)/3 * GameManager.global_loot_mult
		get_parent().enemy_died(self)
		get_parent().get_node("plr").add_xp(xp_given)
		emit_signal("died", self)
		queue_free()

func knockback(from_pos, strength):
	var dir = (global_position - from_pos).normalized()
	kb_velocity += dir * strength
