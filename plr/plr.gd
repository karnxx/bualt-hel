extends CharacterBody2D

signal plr_dmged
signal plr_secon
signal dashd
signal fired

var is_rel = false
var can_rel = true
var recoil_velocity: Vector2 = Vector2.ZERO
var recoil_strength: float = 650.0
var recoil_decay: float = 2200.0

var xp = 0
var lvl = 0
var xp_req = 75 * pow(1.15, lvl)


var exploding = false
var homing = false
var chunky = false
var ricochet = false

var is_invincible = false
var pierce = 0

var max_health = 100
var health = max_health

var magazine = 10
var current_bullets = magazine

var can_shoot := true
var base_spd := 400.0
var base_bullet_dmg := 10
var base_bullet_spd := 600
var base_fire_rate := 1.0
var current_spd := base_spd
var current_bullet_dmg := base_bullet_dmg
var current_bullet_spd := base_bullet_spd
var current_fire_rate := base_fire_rate
var upgrades_applied := []
var current_class : Class
var class_chosen = false
var showing_upgrades = false
var primscript 
var secscript
var passive 
var can_secondary = true
var blinking = false

var BULET = preload("res://plr/bulet.tscn")

var bulet = BULET

var can_dash = true
var is_dashing = false
var dash_speed = 900
var dash_cd = 2
var dashtime = 0.3

var upgdata := {}

var crit := 0.05
var critmult := 1.1

var spread_deg := 2.0

var check1 = false
var check2 = false

@onready var class_picker: Control = $CanvasLayer/class_picker
@onready var upg_picker: Control = $CanvasLayer/upg_picker
func _ready() -> void:
	UpgMgr.establish_plr(self)
	eq_class(preload("res://classes/basic/basic.tres"))
	upg_picker.chosen.connect(on_upg_chosen)
	class_picker.class_chosen.connect(on_class_chosen)

func _process(_delta: float) -> void:
	invinci()
	lvl_upper()
	lvl_milestone()
	if ui_open():
		return
	primary()
	secondary() 
	if Input.is_action_just_pressed("dash"):
		dash()

func invinci():
	if blinking:
		return
	while is_invincible:
		blinking = true
		$AnimatedSprite2D.visible = false
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.visible = true
		await get_tree().create_timer(0.1).timeout
		blinking = false

func _physics_process(delta):
	if ui_open():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction.length() > 0:
		direction = direction.normalized()

	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				$AnimatedSprite2D.play("walk side")
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.play("walk side")
				$AnimatedSprite2D.flip_h = true
		elif abs(direction.y) > abs(direction.x):
			if direction.y > 0:
				$AnimatedSprite2D.play("walk down")
			else:
				$AnimatedSprite2D.play("walk up")
		else:
			if direction.x > 0 and direction.y < 0:
				$AnimatedSprite2D.play("walk top side")
				$AnimatedSprite2D.flip_h = false
			elif direction.x < 0 and direction.y < 0:
				$AnimatedSprite2D.play("walk top side")
				$AnimatedSprite2D.flip_h = true
			elif direction.x > 0 and direction.y > 0:
				$AnimatedSprite2D.play("walk bottom side")
				$AnimatedSprite2D.flip_h = false
			elif direction.x < 0 and direction.y > 0:
				$AnimatedSprite2D.play("walk bottom side")
				$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.stop()

	var move_velocity := direction * current_spd
	if is_dashing:
		move_velocity = direction * (current_spd + dash_speed)

	velocity = move_velocity + recoil_velocity
	move_and_slide()

	recoil_velocity = recoil_velocity.move_toward(Vector2.ZERO, recoil_decay * delta)


func primary():
	if Input.is_action_pressed("primary") and can_shoot and current_bullets > 0:
		can_shoot = false
		primscript.primary(self, get_global_mouse_position())
		var recoil_dir = ($pivot/gun/origin.global_position - get_global_mouse_position()).normalized()
		recoil_velocity += recoil_dir * recoil_strength
		emit_signal('fired')
		$shoot.wait_time = current_fire_rate
		$shoot.start()

func secondary():
	if current_class.nam == "RISK":
		if Input.is_action_just_pressed("secondary") and can_secondary:
			if current_bullets > 0:
				can_secondary = false
				secscript.secondary(self)
				emit_signal('plr_secon')
	elif current_class.nam == 'BURST':
		if Input.is_action_just_pressed("secondary") and can_secondary and current_bullets> 0:
			can_secondary = false
			secscript.secondary_pressed(self)
			emit_signal('plr_secon')
		if Input.is_action_just_released("secondary"):
			secscript.secondary_released()
			
	elif current_class.nam == 'TIME' or current_class.nam == 'SEEK':
		if Input.is_action_just_pressed("secondary") and can_secondary:
			can_secondary = false
			secscript.secondary(self, get_global_mouse_position())
			emit_signal('plr_secon')
	


func on_class_chosen(clas):
	eq_class(clas)
	class_picker.hide()
	$CanvasLayer/hud.move_to_front()
	class_chosen = true
	get_tree().paused = false
	

func on_upg_chosen(upg_script):
	var upg = upg_script.new()
	upg.apply_upgrade(self)
	showing_upgrades = false
	$CanvasLayer/hud.move_to_front()
	get_tree().paused = false

func eq_upg(upg:Script):
	var u = upg.new()
	u.apply_upgrade(self)
	upgrades_applied.append(u)

func eq_class(clas:Class):
	
	current_class = clas
	if clas.primary:
		primscript = clas.primary.new()
		add_child(primscript)
	if clas.secondary:
		secscript = clas.secondary.new()
		add_child(secscript)
	if clas.passive:
		passive = clas.passive.new()
		add_child(passive)
	current_spd = clas.base_spd
	current_fire_rate = clas.base_fire_cd
	current_bullet_dmg =clas.base_dmg
	current_bullet_spd = clas.base_bullet_speed
	print(clas.magazine)
	magazine = clas.magazine 
	recoil_strength = recoil_strength + (current_bullet_dmg * 7)
	for i in clas.upgrades:
		eq_upg(i)

func add_xp(eexp):
	xp += eexp

func lvl_upper():
	if xp < xp_req:
		return
	
	xp -= xp_req
	lvl += 1
	xp_req = 150 * pow(1.15, lvl)
	
	if class_chosen:
		get_tree().paused = true
		showing_upgrades = true
		var choices = UpgMgr.get_random_upg(3)
		upg_picker.show_upg(choices)


func lvl_milestone():
	if lvl == 1 and !class_chosen:
		class_picker.show()
		class_picker.move_to_front()
		get_tree().paused = true
	elif lvl >= 3 and not check1:
		if check1 == true:
			return
		GameManager.global_enemy_bullet_spd *= 1.03
		GameManager.global_enemy_dmg_scale *= 1.05
		check1 = true
	elif lvl >= 6 and not check2:
		if check2 == true:
			return
		GameManager.global_enemy_bullet_spd *= 1.05
		GameManager.global_enemy_dmg_scale *= 1.07
		check2 = true

func dash():
	if can_dash == false:
		return
	is_dashing = true
	can_dash = false
	emit_signal('dashd')
	get_tree().create_timer(dash_cd).timeout.connect(dash_c)
	get_tree().create_timer(dashtime).timeout.connect(dashdone)

func dashdone():
	is_dashing = false

func dash_c():
	can_dash = true

func get_dmged(dmg, dmg_type=GameManager.DamageType.CHIP):
	if not is_invincible and not is_dashing:
		var dmag = dmg
		if is_rel:
			dmag *= 2
		health -= dmag
		is_invincible = true
		if can_rel and dmg_type == GameManager.DamageType.IMPACT:
			reload()
		$Timer.start()
		emit_signal('plr_dmged')
		if health <= 0:
			get_tree().call_deferred('reload_current_scene')

func _on_timer_timeout() -> void:
	is_invincible = false
	

func ui_open():
	return class_picker.visible or upg_picker.visible

func reload():
	if !can_rel:
		return
	print("RELOAD TRIGGERED")
	is_rel = true
	current_bullets = magazine
	can_rel = false
	$reload.start()

func _on_reload_timeout() -> void:
	can_rel = true
	is_rel = false
	
func _on_shoot_timeout() -> void:
	can_shoot = true
