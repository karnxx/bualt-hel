extends CharacterBody2D

var kb_velocity: Vector2 = Vector2.ZERO
var kb_strength := 420.0
var kb_decay := 1600.0 

var maxhealth = 30
var health = 30
var xp_given = randi_range(2*health,4*health)/3 * GameManager.global_loot_mult
var dmg = randi_range(5,6) * GameManager.global_enemy_dmg_scale
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr 
var current_bullet_dmg = dmg * GameManager.global_enemy_dmg_scale
var current_bullet_spd = 00
var spd = 200
var pathfind = true
var dir:= Vector2.RIGHT.rotated(randf() * 2 * PI)
var candarop = true
var chip = true
var elite = false

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
		get_parent().enemy_died(self)
		get_parent().get_node('plr').add_xp(xp_given)
		emit_signal('died', self)
		self.queue_free()
		

func _physics_process(delta: float) -> void:
	if pathfind:
		shoot()
	
	if is_on_wall():
		dir = Vector2.RIGHT.rotated(randf() * 2 * PI)
	var move_vel = dir * spd
	velocity = move_vel + kb_velocity
	move_and_slide()
	kb_velocity = kb_velocity.move_toward(
		Vector2.ZERO,
		kb_decay * delta
	)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('plr'):
		body.get_dmged(dmg)
		pathfind = false

func shoot():
	if !candarop:
		return
	var buloat = BULET_FROMENMY.instantiate()
	get_parent().add_child(buloat)
	buloat.global_position = global_position
	buloat.shoot(self, Vector2.ZERO)
	candarop = false
	await get_tree().create_timer(0.05).timeout
	candarop = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('plr'):
		await get_tree().create_timer(1).timeout
		pathfind = true


func _on_timer_timeout() -> void:
	dir = Vector2.RIGHT.rotated(randf() * 2 * PI)
	$Timer.wait_time = randf_range(1.0,2.5)
func knockback(from_pos,strength):
	var dir_kb = (global_position - from_pos).normalized()
	kb_velocity += dir_kb * strength
