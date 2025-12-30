extends CharacterBody2D
var health = 20
var xp_given = randi_range(100,200) * GameManager.global_loot_mult
var dmg = randi_range(1,10) * GameManager.global_enemy_dmg_scale
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr 
var current_bullet_dmg = 10
var current_bullet_spd = 600
var speed = 600
var pathfind = true
var elite = false
var cd = 1
func get_dmged(dtmg):
	health -= dtmg
	if health <= 0:
		self.queue_free()
		get_parent().get_node('plr').add_xp(xp_given)

func _physics_process(_delta: float) -> void:
	if pathfind:
		shoot()
	move_and_slide()

func _ready() -> void:
	if elite:
		$Sprite2D.scale = 2
		$Sprite2D.modulate = Color.WEB_PURPLE
		$CollisionShape2D.scale = 2
		speed = 800
		cd = 0.6

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('plr'):
		body.get_dmged(dmg)
		pathfind = false

func shoot():
	var target = get_parent().get_node('plr').global_position
	var start = global_position
	var dir = (target-start).normalized()
	velocity = dir * speed * GameManager.time_scale

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('plr'):
		await get_tree().create_timer(cd).timeout
		pathfind = true
