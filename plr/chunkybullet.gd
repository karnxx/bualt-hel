extends CharacterBody2D
var dmg
var pierce = 0
var dmg_mult = 4
const BULET = preload("res://plr/bulet.tscn")

var split_count := 2
var split_angle := 30
var can_split := true
var target: Node2D = null
var homer = false
var turn_rate := deg_to_rad(90)
var spd
var crit 
var critdmg
var plr 
func _ready() -> void:
	await get_tree().create_timer(5).timeout
	self.queue_free()

func shoot(pglr, dir, plar):
	dmg = pglr.current_bullet_dmg
	spd = pglr.current_bullet_spd
	plr = plar
	velocity = dir.normalized() * spd
	rotation = dir.angle()
	dmg_mult = plar.upgdata.get('chunkmult', 4)
	crit = plr.crit
	critdmg = plr.critmult

func split():
	if !can_split:
		return

	can_split = false

	var base_dir = velocity.normalized()
	var angle_step = deg_to_rad(split_angle)

	for i in range(split_count):
		var new_bullet = BULET.instantiate()
		new_bullet.global_position = global_position
		
		var offset = i - (split_count - 1) / 2.0
		var new_dir = base_dir.rotated(angle_step * offset)
		new_bullet.dmg = round(dmg/dmg_mult)
		new_bullet.velocity = new_dir * velocity.length()
		new_bullet.rotation = new_dir.angle()
		new_bullet.dmg = dmg
		new_bullet.pierce = 0
		new_bullet.scale = scale * 0.5

		get_tree().current_scene.add_child(new_bullet)



func _on_area_2d_body_entered(body: Node2D) -> void:
	crit = plr.crit
	critdmg = plr.critmult
	if body.has_method('get_dmged') and body.is_in_group('enemy'):
		body.get_dmged(dmg)
		call_deferred('split')
		if pierce <= 0:
			self.queue_free()
		else:
			pierce -=1

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
