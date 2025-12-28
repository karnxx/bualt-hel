extends CharacterBody2D

var dmg
var speed
var target: Node2D = null
var pierce = 0
var turn_rate := deg_to_rad(90)

func shoot(plr, dir):
	dmg = plr.current_bullet_dmg
	speed = plr.current_bullet_spd
	velocity = dir.normalized() * speed
	rotation = dir.angle()

func _physics_process(delta):
	if target and is_instance_valid(target):
		var desired_dir = (target.global_position - global_position).normalized()
		var current_dir = velocity.normalized()

		var angle_diff = current_dir.angle_to(desired_dir)
		var max_turn = turn_rate * delta
		var turn = clamp(angle_diff, -max_turn, max_turn)

		current_dir = current_dir.rotated(turn)
		velocity = current_dir * speed
		rotation = current_dir.angle()

	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.has_method("get_dmged"):
		body.get_dmged(dmg)
		if pierce <= 0:
			queue_free()
