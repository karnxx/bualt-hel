extends CharacterBody2D

var kb_velocity: Vector2 = Vector2.ZERO
var kb_strength := 420.0
var kb_decay := 1600.0 

var maxhealth = 30
var health = 30
var xp_given = randi_range(2 * health, 4 * health)/3 * GameManager.global_loot_mult
var dmg = 2 * GameManager.global_enemy_dmg_scale
var cd = 0.3
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")

var current_bullet_dmg = dmg * GameManager.global_enemy_dmg_scale
var current_bullet_spd = GameManager.global_enemy_bullet_spd
var canshot := true
var elite := false
var chip = true
var plr: Node2D
var flank_offset: Vector2 = Vector2.ZERO
var flank_distance := 140.0
var spd := 160.0
var flank_side := 1
var can_split := true
var shoot_cd := 1.0

signal died(who)

func _ready() -> void:
	plr = get_parent().get_node("plr")
	flank_side = 1 if randf() < 0.5 else -1

	if elite:
		$Sprite2D.scale *= 2
		$Sprite2D.modulate = Color.WEB_PURPLE
		$CollisionShape2D.scale *= 2
		health *= 2
		flank_distance *= 1.2
		spd *= 1.1

	update_flank()
	$Timer.start()

func _physics_process(delta: float) -> void:
	if not plr:
		return

	var target_pos = plr.global_position + flank_offset
	var dir = (target_pos - global_position).normalized()
	velocity = (dir * spd + kb_velocity) * GameManager.time_scale
	move_and_slide()
	kb_velocity = kb_velocity.move_toward(Vector2.ZERO, kb_decay * delta)

	if canshot:
		fire_bullet()

func fire_bullet():
	canshot = false
	if not plr:
		canshot = true
		return

	var bullet = BULET_FROMENMY.instantiate()
	bullet.global_position = global_position
	get_parent().add_child(bullet)
	var dir = (plr.global_position - global_position).normalized()
	bullet.shoot(self, dir)

	await get_tree().create_timer(cd).timeout
	canshot = true

func update_flank():
	if not plr:
		return
	var to_player = (plr.global_position - global_position).normalized()
	var perpendicular = to_player.orthogonal() * flank_side
	flank_offset = flank_offset.lerp(perpendicular * flank_distance, 0.08)

func _on_Timer_timeout():
	if randf() < 0.3:
		flank_side *= -1
	update_flank()
	$Timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("plr"):
		body.get_dmged(dmg)

func get_dmged(dtmg):
	health -= dtmg
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.modulate = Color.WHITE

	if health <= 0:
		xp_given = randi_range(2 * maxhealth, 4 * maxhealth)/3 * GameManager.global_loot_mult
		get_parent().enemy_died(self)
		get_parent().get_node("plr").add_xp(xp_given)
		emit_signal("died", self)

		if can_split:
			for i in range(3):
				var pos = global_position + Vector2(randi_range(-20, 20), randi_range(-20, 20))
				var instance = preload("res://plr/splitter.tscn").instantiate()
				instance.global_position = pos
				instance.can_split = false
				instance.get_node("CollisionShape2D").scale *= 0.4
				instance.get_node("Sprite2D").scale *= 0.4
				instance.health /= 3
				instance.maxhealth /= 3
				instance.cd /= 3
				get_parent().add_child(instance)

		queue_free()

func knockback(pos, strength):
	var dir = (global_position - pos).normalized()
	kb_velocity += dir * strength
