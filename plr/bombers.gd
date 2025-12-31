extends CharacterBody2D
var health = 20
var xp_given = randi_range(2*health,4*health) * GameManager.global_loot_mult
var dmg = randi_range(1,10) * GameManager.global_enemy_dmg_scale
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr 
var current_bullet_dmg = 10  * GameManager.global_enemy_dmg_scale
var current_bullet_spd = GameManager.global_enemy_bullet_spd
var speed = 600
var pathfind = true
var elite = false
var cd = 1

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
	move_and_slide()

func _ready() -> void:
	if elite:
		$Sprite2D.scale *= 2
		$Sprite2D.modulate = Color.WEB_PURPLE
		$CollisionShape2D.scale *= 2
		speed = 800
		cd = 0.6
		health /= 2

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('plr'):
		explode()

func explode():
	var tween := create_tween()
	tween.tween_property($Sprite2D, "scale", $Sprite2D.scale * 2.0, 0.5)
	tween.parallel().tween_property($CollisionShape2D, "scale", $CollisionShape2D.scale * 2.0, 0.5)
	tween.parallel().tween_property($Sprite2D, "modulate", Color.BLACK, 0.5)

	await tween.finished
	$Area2D2.monitoring = true
	await get_tree().process_frame
	queue_free()

func shoot():
	var target = get_parent().get_node('plr').global_position
	var start = global_position
	var dir = (target-start).normalized()
	velocity = dir * speed * GameManager.time_scale

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('plr'):
		await get_tree().create_timer(cd).timeout
		pathfind = true

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	print('asd')
	body.get_dmged(40)
