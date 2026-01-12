extends CharacterBody2D

var kb_velocity: Vector2 = Vector2.ZERO
var kb_strength := 420.0
var kb_decay := 1600.0 

var maxhealth = 20
var health = 20
var xp_given = randi_range(2*health,4*health)/3 * GameManager.global_loot_mult
var dmg = randi_range(10,30) * GameManager.global_enemy_dmg_scale
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr 
var current_bullet_dmg = 10  * GameManager.global_enemy_dmg_scale
var current_bullet_spd = GameManager.global_enemy_bullet_spd
var spd = 300
var pathfind = true
var elite = false
var cd = 1
var chip = false
var move
var can_Explo = true
signal died(who)

func get_dmged(dtmg):
	health -= dtmg
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.modulate = Color.WHITE
	GameManager.emit_signal('enemydmg', self)
	if health <= 0:
		xp_given = randi_range(2 * maxhealth, 4 * maxhealth)/3 * GameManager.global_loot_mult
		get_parent().enemy_died(self)
		get_parent().get_node('plr').add_xp(xp_given)
		emit_signal('died', self)
		self.queue_free()

func _physics_process(delta: float) -> void:
	if pathfind:
		shoot()
	velocity = kb_velocity + move
	move_and_slide()
	kb_velocity = kb_velocity.move_toward(
		Vector2.ZERO,
		kb_decay * delta
	)

func _ready() -> void:
	if elite:
		$Sprite2D.scale *= 2
		$Sprite2D.modulate = Color.WEB_PURPLE
		$CollisionShape2D.scale *= 2
		spd = 800
		cd = 0.6
		health /= 2

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('plr'):
		explode()

func knockback(pos, strength):
	var dir = (global_position - pos).normalized()
	kb_velocity += dir * strength

func explode():
	if can_Explo == false:
		return
	can_Explo = false
	var twen := create_tween()
	twen.tween_property($Sprite2D2, "modulate", Color(0.545098, 0, 0, 1), 0.5)
	velocity = Vector2.ZERO
	move = Vector2.ZERO
	pathfind = false
	await twen.finished
	twen.stop()
	var twen3 := create_tween()
	$Area2D2.monitoring = true
	twen3.tween_property($Sprite2D2, "modulate", Color.RED, 0.1)
	await get_tree().create_timer(0.1).timeout
	$Area2D2.monitoring = false
	var twen2 := create_tween()
	twen2.tween_property($Sprite2D2, "modulate", Color(0,0,0,0), 0.2)
	pathfind = false
	await get_tree().create_timer(2).timeout
	can_Explo = true

func shoot():
	if !pathfind:
		return
	var target = get_parent().get_node('plr').global_position
	var start = global_position
	var dir = (target-start).normalized()
	move = dir * spd * GameManager.time_scale

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('plr'):
		await get_tree().create_timer(cd).timeout
		pathfind = true

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemy') or body.is_in_group('plr'):
		body.get_dmged(body.max_health * 0.05, GameManager.DamageType.IMPACT)
