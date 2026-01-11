extends CharacterBody2D

var kb_velocity: Vector2 = Vector2.ZERO
var kb_strength := 420.0
var kb_decay := 1600.0 

var maxhealth = 40
var health = 30
var xp_given = randi_range(2*health,4*health)/3 * GameManager.global_loot_mult
var dmg = randi_range(8,9) * GameManager.global_enemy_dmg_scale
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr 
var current_bullet_dmg = dmg * GameManager.global_enemy_dmg_scale
var current_bullet_spd = GameManager.global_enemy_bullet_spd
var speed = 600
var spd = 6
var pathfind = true
var dirs = [Vector2.UP, Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN]
var dir1 = dirs.pick_random()
var dir2 = dirs.pick_random()
var dir3 = dirs.pick_random()
var can_shot := true
var elite = false
var chip = false
var shoot_cd := 1.0
var shoot_timer := 0.0

signal died(who)

func _ready() -> void:
	$Timer.start()
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.modulate = Color.WHITE
	if elite:
		$Sprite2D.scale *= 2
		$Sprite2D.modulate = Color.WEB_PURPLE
		$CollisionShape2D.scale *= 2
		health /= 2

func get_dmged(dtmg):
	health -= dtmg
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.modulate = Color.WHITE
	GameManager.emit_signal('enemydmg', self)
	if health <= 0:
		xp_given = randi_range(2 * maxhealth, 4 * maxhealth)/3 * GameManager.global_loot_mult
		get_parent().enemy_died()
		get_parent().get_node('plr').add_xp(xp_given)
		emit_signal('died', self)
		self.queue_free()

func _physics_process(delta: float) -> void:
	var move_velocity := Vector2.ZERO
	velocity = move_velocity + kb_velocity
	move_and_slide()
	kb_velocity = kb_velocity.move_toward(Vector2.ZERO, kb_decay * delta)

	plr = get_parent().get_node("plr")
	shoot_timer -= delta
	if shoot_timer <= 0:
		fire_angles()
		shoot_timer = shoot_cd

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('plr'):
		body.get_dmged(dmg)
		pathfind = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('plr'):
		await get_tree().create_timer(1).timeout
		pathfind = true

func fire_angles():
	if not can_shot:
		return
	can_shot = false

	if dir1 == dir2:
		dir2 = dirs.pick_random()
	if elite:
		if dir3 == dir1 or dir3 == dir2:
			dir3 = dirs.pick_random()

	var b1 = BULET_FROMENMY.instantiate()
	var b2 = BULET_FROMENMY.instantiate()
	b1.global_position = global_position
	b2.global_position = global_position
	get_parent().add_child(b1)
	get_parent().add_child(b2)
	b1.shoot(self, dir1)
	b2.shoot(self, dir2)

	if elite:
		var b3 = BULET_FROMENMY.instantiate()
		b3.global_position = global_position
		get_parent().add_child(b3)
		b3.shoot(self, dir3)

	await get_tree().create_timer(shoot_cd).timeout
	can_shot = true

func knockback(pos, strength):
	var dir = (global_position - pos).normalized()
	kb_velocity += dir * strength

func _on_timer_timeout() -> void:
	dir1 = dirs.pick_random()
	dir2 = dirs.pick_random()
	if elite:
		dir3 = dirs.pick_random()
	$Timer.start()
