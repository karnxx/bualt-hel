extends CharacterBody2D

var kb_velocity: Vector2 = Vector2.ZERO
var kb_strength := 420.0
var kb_decay := 1600.0 
var maxhealth = 30
var health = 30
var xp_given = randi_range(2*health,4*health)/3 * GameManager.global_loot_mult
var dmg = randi_range(1,2) * GameManager.global_enemy_dmg_scale
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr 
var current_bullet_dmg = dmg * GameManager.global_enemy_dmg_scale
var current_bullet_spd = GameManager.global_enemy_bullet_spd + 200
var spd = 100
var pathfind = true
var can_shot = true
var elite = false
var bulatcircleamt = 30
var cd = 5
var move_velocity

signal died(who)

func _process(_delta: float) -> void:
	fire_circle(global_position)

func get_dmged(dtmg):
	health -= dtmg
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.modulate = Color.WHITE
	GameManager.emit_signal('enemydmg', self)
	if health <= 0:
		xp_given = randi_range(2 * maxhealth, 4 * maxhealth)/3 * GameManager.global_loot_mult
		get_parent().get_node('plr').add_xp(xp_given)
		get_parent().enemy_died()
		emit_signal('died', self)
		self.queue_free()
		

func _physics_process(delta: float) -> void:
	if pathfind:
		shoot()
	move_and_slide()
	velocity = move_velocity + kb_velocity

	kb_velocity = kb_velocity.move_toward(
		Vector2.ZERO,
		kb_decay * delta
	)

func _ready() -> void:
	if elite:
		$Sprite2D.scale *= 2
		$Sprite2D.modulate = Color.WEB_PURPLE
		$CollisionShape2D.scale *= 2
		spd = 200
		bulatcircleamt = 70
		cd = 1.5
		health /= 2

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('plr'):
		body.get_dmged(dmg)
		pathfind = false

func shoot():
	var target = get_parent().get_node('plr').global_position
	var start = global_position
	var dir = (target-start).normalized()
	move_velocity = dir * spd * GameManager.time_scale


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('plr'):
		pathfind = true

func fire_circle(origin):
	if !can_shot:
		return
	
	for i in range(bulatcircleamt):
		var angle = TAU * i / bulatcircleamt
		var dir = Vector2(cos(angle), sin(angle))

		var bulaty = BULET_FROMENMY.instantiate()
		bulaty.global_position = origin
		get_parent().add_child(bulaty)
		bulaty.shoot(self, dir)
	can_shot = false
	await get_tree().create_timer(cd).timeout
	can_shot = true

func knockback(from_pos, strength):
	var dir = (global_position - from_pos).normalized()
	kb_velocity += dir * strength
