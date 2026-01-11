extends CharacterBody2D

signal died(who)

enum State { WALK, WINDUP, CHARGE }

var state = State.WALK

var walk_spd := 160.0
var charge_spd := 900.0

var windup_time := 1.0
var charge_time := 0.4

var charge_dir := Vector2.ZERO

var kb_velocity := Vector2.ZERO
var kb_decay := 1600.0
var elite = false

var maxhealth := 20
var health := 20
var xp_given = randi_range(2*health,4*health)/3 * GameManager.global_loot_mult
var plr

func _ready() -> void:
	plr = get_parent().get_node("plr")

func _physics_process(delta: float) -> void:
	match state:
		State.WALK:
			move_to_player()

		State.WINDUP:
			velocity = Vector2.ZERO

		State.CHARGE:
			velocity = charge_dir * charge_spd * GameManager.time_scale

	velocity += kb_velocity
	move_and_slide()

	kb_velocity = kb_velocity.move_toward(Vector2.ZERO, kb_decay * delta)

func move_to_player():
	if not plr:
		return

	var to_plr = plr.global_position - global_position
	var dist = to_plr.length()

	if dist < 220:
		start_windup()
		return

	velocity = to_plr.normalized() * walk_spd * GameManager.time_scale


func start_windup():
	if state != State.WALK:
		return

	state = State.WINDUP
	$Sprite2D.modulate = Color.ORANGE

	await get_tree().create_timer(windup_time).timeout
	if not is_instance_valid(plr):
		return

	charge_dir = (plr.global_position - global_position).normalized()
	start_charge()


func start_charge():
	state = State.CHARGE
	$Sprite2D.modulate = Color.RED

	await get_tree().create_timer(charge_time).timeout

	state = State.WALK
	$Sprite2D.modulate = Color.WHITE


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("plr"):
		return

	if state == State.CHARGE:
		body.get_dmged(body.max_health * 0.1, GameManager.DamageType.IMPACT)
	else:
		body.get_dmged(body.max_health * 0.01, GameManager.DamageType.CHIP)

func get_dmged(dmg):
	health -= dmg
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = Color.WHITE

	if health <= 0:
		xp_given = randi_range(2*maxhealth,4*maxhealth)/3 * GameManager.global_loot_mult
		get_parent().get_node('plr').add_xp(xp_given)
		get_parent().enemy_died()
		emit_signal("died", self)
		queue_free()

func knockback(from_pos, strength):
	var dir = (global_position - from_pos).normalized()
	kb_velocity += dir * strength
