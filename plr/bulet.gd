extends CharacterBody2D
var dmg
var pierce = 0
var homer = false
var turn_rate := deg_to_rad(90)
var spd
var target :Node2D= null
var crit 
var critdmg

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	self.queue_free()

func shoot(plr, dir, plar):
	dmg = plr.current_bullet_dmg
	spd = plr.current_bullet_spd
	velocity = dir.normalized() * spd
	rotation = dir.angle()
	crit = plar.crit
	critdmg = plar.critmult

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method('get_dmged') and body.is_in_group('enemy'):
		var rand = randf()
		if rand <= crit:
			body.get_dmged(dmg * critdmg)
		else:
			body.get_dmged(dmg)
		if pierce <= 0:
			self.queue_free()
		else:
			pierce -= 1

func _physics_process(delta):
	if target and is_instance_valid(target) and homer:
		var desired_dir = (target.global_position - global_position).normalized()
		var current_dir = velocity.normalized()

		var angle_diff = current_dir.angle_to(desired_dir)
		var max_turn = turn_rate * delta
		var turn = clamp(angle_diff, -max_turn, max_turn)

		current_dir = current_dir.rotated(turn)
		velocity = current_dir * spd
		rotation = current_dir.angle()
	move_and_slide()
