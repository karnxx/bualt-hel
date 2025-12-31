extends CharacterBody2D
var health = 50
var xp_given = randi_range(2*health,4*health) * GameManager.global_loot_mult
var dmg = randi_range(1,10) * GameManager.global_enemy_dmg_scale
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr 
var current_bullet_dmg = 10 * GameManager.global_enemy_dmg_scale
var current_bullet_spd = 00
var speed = 200
var pathfind = true
var dir:= Vector2.RIGHT.rotated(randf() * 2 * PI)
var candarop = true

var elite = false
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
		self.queue_free()
		

func _physics_process(_delta: float) -> void:
	if pathfind:
		shoot()
	if is_on_wall():
		dir = Vector2.RIGHT.rotated(randf() * 2 * PI)
	velocity = dir * speed
	move_and_slide()


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
