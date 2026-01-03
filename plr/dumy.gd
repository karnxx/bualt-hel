extends CharacterBody2D

var kb_velocity: Vector2 = Vector2.ZERO
var kb_strength := 420.0
var kb_decay := 1600.0 

var maxhealth = 60
var health = 60
var xp_given = randi_range(2*health,4*health) * GameManager.global_loot_mult
var dmg = randi_range(1,10) * GameManager.global_enemy_dmg_scale
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr 
var current_bullet_dmg = 5  * GameManager.global_enemy_dmg_scale
var current_bullet_spd = GameManager.global_enemy_bullet_spd

var elite = false

signal died(who)

func _physics_process(delta: float) -> void:
	velocity = kb_velocity
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
		health *= 2

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


func _process(_delta: float) -> void:
	plr = get_parent().get_node('plr')
	shoot()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('plr'):
		body.get_dmged(dmg)

func shoot():
	await get_tree().create_timer(1).timeout
	var origin = global_position
	var dir = (plr.global_position - origin).normalized()
	var bulat = BULET_FROMENMY.instantiate()
	bulat.global_position = origin
	self.get_parent().add_child(bulat)
	bulat.shoot(self, dir)

func knockback(pos, strength):
	var dir = (global_position - pos).normalized()
	kb_velocity += dir * strength
