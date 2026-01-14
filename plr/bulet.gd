extends CharacterBody2D

var dmg
var pierce = 0
var spd
var crit
var critdmg
var plr

var homer := false
var chunky := false
var ricochet := false
var exploding = false

var target: Node2D = null
var turn_rate := deg_to_rad(70)
var homing_delay := 0.0
var homing_timer := 0.0

const BULLET = preload("res://plr/bulet.tscn")
var split_count := 2
var split_angle := 30
var can_split := true
var dmg_mult := 4
var kb
var bounces := 0
var spd_dec := 2.0

var lifetime := 0.0
const MAX_LIFE := 4.0

func _ready():
	set_physics_process(true)

func shoot(pglr, dir, plar):
	dmg = pglr.current_bullet_dmg
	spd = pglr.current_bullet_spd
	plr = plar
	velocity = dir.normalized() * spd
	rotation = velocity.angle()
	crit = plr.crit
	critdmg = plr.critmult
	homing_timer = 0
	lifetime = 0
	can_split = true
	kb = plr.kb
	if chunky:
		dmg_mult = plar.upgdata["chunky"]["chunkmult"]
		split_count = plar.upgdata["chunky"]["chunks"]

	if ricochet:
		bounces = plar.upgdata["ricochet"]["bounces"]
		spd_dec = plar.upgdata["ricochet"]["spd_dec"]

func split():
	if not can_split:
		return
	can_split = false

	var base_dir = velocity.normalized()
	var step = deg_to_rad(split_angle)

	for i in range(split_count):
		var b = BULLET.instantiate()
		var offset = i - (split_count - 1) / 2.0
		var dir = base_dir.rotated(step * offset)
		b.global_position = global_position
		b.velocity = dir * velocity.length()
		b.rotation = dir.angle()
		b.dmg = int(dmg / dmg_mult)
		b.pierce = 0
		b.scale = scale * 0.6
		get_tree().current_scene.add_child(b)

func add_explo():
	var e = preload("res://plr/explode.tscn").instantiate()
	e.global_position = global_position
	get_parent().add_child(e)



func _on_area_2d_body_entered(body):
	if not body.is_in_group("enemy"):
		return
	plr = get_parent().get_node('plr')
	var dealt = dmg
	crit = plr.crit
	critdmg = plr.critmult
	if randf() <= crit:
		dealt *= critdmg
	body.get_dmged(dealt)

	if chunky:
		split()

	if pierce > 0:
		pierce -= 1
		return

	if exploding:
		call_deferred('add_explo')
	
	if kb != null:
		body.knockback(self.global_position, kb)
	queue_free()

func _physics_process(delta):
	lifetime += delta
	if lifetime >= MAX_LIFE:
		queue_free()
		return

	homing_timer += delta
	if homer and homing_timer >= homing_delay and target and is_instance_valid(target):
		var seek_power = clamp(plr.upgdata["seek"]["seekpower"], 0.01, 0.06)
		var desired = (target.global_position - global_position).normalized()
		velocity = velocity.normalized().lerp(desired, seek_power) * spd
		rotation = velocity.angle()

	if ricochet:
		var col = move_and_collide(velocity * delta)
		if col:
			var n = col.get_normal()
			if bounces > 0:
				velocity = velocity.bounce(n) / spd_dec
				bounces -= 1
			else:
				queue_free()
	else:
		move_and_slide()
