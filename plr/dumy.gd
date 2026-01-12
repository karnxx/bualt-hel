extends CharacterBody2D

var kb_velocity: Vector2 = Vector2.ZERO
var kb_strength := 420.0
var kb_decay := 1600.0
var maxhealth = 60
var health = 60
var xp_given = randf_range(2*health,4*health)/3 * GameManager.global_loot_mult
var dmg = randi_range(9,10) * GameManager.global_enemy_dmg_scale
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr 
var current_bullet_dmg = dmg  * GameManager.global_enemy_dmg_scale
var current_bullet_spd = GameManager.global_enemy_bullet_spd
var spd = 6
var elite = false

signal died(who)

var shoot_cd := 2.5
var shoot_timer := 0.0
var is_firing := false
var chip = false

func _physics_process(delta: float) -> void:
	velocity = kb_velocity
	move_and_slide()
	kb_velocity = kb_velocity.move_toward(Vector2.ZERO, kb_decay * delta)

func _ready() -> void:
	if elite:
		$Sprite2D.scale *= 2
		$Sprite2D.modulate = Color.WEB_PURPLE
		$CollisionShape2D.scale *= 2
		health *= 2

func get_dmged(dtmg):
	health -= dtmg
	for i in range(4):
		$Sprite2D.modulate = Color.YELLOW
		await get_tree().create_timer(0.2).timeout
		$Sprite2D.modulate = Color.WHITE
		await get_tree().create_timer(0.2).timeout
	GameManager.emit_signal('enemydmg', self)
	if health <= 0:
		xp_given = randi_range(2 * maxhealth, 4 * maxhealth)/3 * GameManager.global_loot_mult
		get_parent().enemy_died(self)
		get_parent().get_node('plr').add_xp(xp_given)
		emit_signal('died', self)
		self.queue_free()

func _process(delta: float) -> void:
	plr = get_parent().get_node("plr")
	if is_firing:
		return
	shoot_timer -= delta	
	if shoot_timer <= 0:
		fire_beam()
		shoot_timer = shoot_cd

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('plr'):
		body.get_dmged(dmg, GameManager.DamageType.IMPACT)

func fire_beam():
	if not plr:
		return
	is_firing = true
	$Sprite2D.modulate = Color(1, 0.6, 0.6)
	await get_tree().create_timer(0.3).timeout
	$Sprite2D.modulate = Color.WHITE
	var dir = (plr.global_position - global_position).normalized()
	for i in range(5):
		var bullet = BULET_FROMENMY.instantiate()
		bullet.global_position = global_position
		get_parent().add_child(bullet)
		bullet.shoot(self, dir)
		await get_tree().create_timer(0.08).timeout
	is_firing = false

func knockback(pos, strength):
	var dir = (global_position - pos).normalized()
	kb_velocity += dir * strength
