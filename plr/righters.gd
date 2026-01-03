extends CharacterBody2D

var kb_velocity: Vector2 = Vector2.ZERO
var kb_strength := 420.0
var kb_decay := 1600.0 

var maxhealth = 40
var health = 40
var xp_given = randi_range(2*health,4*health) * GameManager.global_loot_mult
var dmg = randi_range(1,10) * GameManager.global_enemy_dmg_scale
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr 
var current_bullet_dmg = 20 * GameManager.global_enemy_dmg_scale
var current_bullet_spd = GameManager.global_enemy_bullet_spd
var speed = 600
var pathfind = true
var dirs = [Vector2.UP,Vector2.RIGHT,Vector2.LEFT,Vector2.DOWN]
var dir1 = dirs.pick_random()
var dir2 = dirs.pick_random()
var dir3 = dirs.pick_random()
var can_shot = true

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
	if health <= 0:
		get_parent().enemy_died()
		get_parent().get_node('plr').add_xp(xp_given)
		emit_signal('died', self)
		self.queue_free()
		

func _physics_process(delta: float) -> void:
	var move_velocity := Vector2.ZERO
	if pathfind:
		move_velocity = Vector2.ZERO
	velocity = move_velocity + kb_velocity
	move_and_slide()
	shoot()
	kb_velocity = kb_velocity.move_toward(
		Vector2.ZERO,
		kb_decay * delta
	)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('plr'):
		body.get_dmged(dmg)
		pathfind = false

func shoot():
	if !can_shot:
		return
	if dir1 == dir2:
		dir2 = dirs.pick_random()
		if elite:
			if dir3 == dir1 or dir3 == dir2:
				dir3 = dirs.pick_random()
	var bulat = BULET_FROMENMY.instantiate()
	var bulat2 = BULET_FROMENMY.instantiate()
	if elite:
		var bulat3 = BULET_FROMENMY.instantiate()
		bulat3.global_position = global_position
		get_parent().add_child(bulat3)
		bulat3.shoot(self, dir3)
	bulat.global_position = global_position
	bulat2.global_position = global_position
	get_parent().add_child(bulat)
	get_parent().add_child(bulat2)
	bulat.shoot(self, dir1)
	bulat2.shoot(self, dir2)
	can_shot = false
	await get_tree().create_timer(1).timeout
	can_shot = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('plr'):
		await get_tree().create_timer(1).timeout
		pathfind = true

func knockback(pos, strength):
	var dir = (global_position - pos).normalized()
	kb_velocity += dir * strength
	
func _on_timer_timeout() -> void:
	dir1 = dirs.pick_random()
	dir2 = dirs.pick_random()
	if elite:
		dir3= dirs.pick_random()
	$Timer.start()
