extends CharacterBody2D

signal plr_dmged
signal plr_secon
signal dashd
signal fired

var recoil_velocity: Vector2 = Vector2.ZERO
var recoil_strength: float = 650.0
var recoil_decay: float = 2200.0

var xp = 0
var lvl = 0
var xp_req = (200 * pow(1.5, lvl))/3

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

var spread_deg := 4.0

@onready var class_picker: Control = $CanvasLayer/class_picker
@onready var upg_picker: Control = $CanvasLayer/upg_picker
func _ready() -> void:
	UpgMgr.establish_plr(self)
	eq_class(preload("res://classes/basic/basic.tres"))
	eq_upg(preload("res://classes/TIME/upgs/PAUSE.gd"))
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
		$Sprite2D.visible = false
		await get_tree().create_timer(0.1).timeout
		$Sprite2D.visible = true
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

	var move_velocity := direction * current_spd

	if is_dashing:
		move_velocity = direction * (current_spd + dash_speed)

	velocity = move_velocity + recoil_velocity
	move_and_slide()

	recoil_velocity = recoil_velocity.move_toward(
		Vector2.ZERO,
		recoil_decay * delta
	)

func primary():
	if Input.is_action_just_pressed("primary"):
		if !can_shoot:
			return
		if current_bullets > 0:
			can_shoot = false
			primscript.primary(self, get_global_mouse_position())
			var recoil_dir = ($pivot/gun/origin.global_position - get_global_mouse_position()).normalized()
			recoil_velocity += recoil_dir * recoil_strength
			emit_signal('fired')
			await get_tree().create_timer(current_fire_rate).timeout
			can_shoot = true
		

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
	for i in clas.upgrades:
		eq_upg(i)

func add_xp(eexp):
	xp += eexp
	print(xp)


func lvl_upper():
	if xp < xp_req:
		return
	
	xp -= xp_req
	lvl += 1
	xp_req =(200 * pow(1.5, lvl))/3
	
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

func get_dmged(dmg):
	if not is_invincible and not is_dashing:
		health -= dmg
		current_bullets = magazine
		is_invincible = true
		$Timer.start()
		emit_signal('plr_dmged')
		if health <= 0:
			get_tree().call_deferred('reload_current_scene')

func _on_timer_timeout() -> void:
	is_invincible = false
	print('no invince')

func ui_open():
	return class_picker.visible or upg_picker.visible
