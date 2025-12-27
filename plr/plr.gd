extends CharacterBody2D

var xp = 0
var lvl = 0
var xp_req = 200 * pow(1.5, lvl)
var is_invincible = false

var max_health = 100
var health = max_health

var magazine = 10
var current_bullets = magazine

var can_shoot := true
var base_spd := 400.0
var base_bullet_dmg := 10
var base_bullet_spd := 600
var base_fire_rate := 1
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
@onready var class_picker: Control = $CanvasLayer/class_picker
@onready var upg_picker: Control = $CanvasLayer/upg_picker
func _ready() -> void:
	UpgMgr.establish_plr(self)
	eq_class(preload("res://classes/basic/basic.tres"))
	upg_picker.chosen.connect(on_upg_chosen)
	class_picker.class_chosen.connect(on_class_chosen)

func _process(delta: float) -> void:
	lvl_upper()
	primary()
	secondary()
	lvl_milestone()

func _physics_process(_delta):
	#var mouse_pos := get_viewport().get_mouse_position()
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction.length() > 0:
		direction = direction.normalized()
	velocity = direction * current_spd
	move_and_slide()

func primary():
	if Input.is_action_just_pressed("primary"):
		if !can_shoot:
			return
		if current_bullets > 0:
			can_shoot = false
			primscript.primary(self, get_viewport().get_camera_2d().get_global_mouse_position())
			current_bullets -= 1
			await get_tree().create_timer(current_fire_rate).timeout
			can_shoot = true

func secondary():
	if current_class.nam != "BURST":
		if Input.is_action_just_pressed("secondary") and can_secondary:
			if current_bullets > 0:
				can_secondary = false
				secscript.secondary(self, get_viewport().get_camera_2d().get_global_mouse_position())
				current_bullets -= 1
				await get_tree().create_timer(10).timeout
				can_secondary = true
	else:
		if Input.is_action_just_pressed("secondary") and can_secondary:
			can_secondary = false
			secscript.secondary_pressed(self)
		if Input.is_action_just_released("secondary") and secscript.charging == true:
			secscript.secondary_released()
			current_bullets -= 1
			await get_tree().create_timer(10).timeout
			can_secondary = true


func on_class_chosen(clas):
	eq_class(clas)
	class_picker.hide()
	class_chosen = true

func on_upg_chosen(upg_script):
	var upg = upg_script.new()
	upg.apply_upgrade(self)
	showing_upgrades = false

func eq_upg(upg:Script):
	var u = upg.new()
	u.apply_upgrade(self)
	upgrades_applied.append(u)

func eq_class(clas:Class):
	current_class = clas
	if clas.primary:
		primscript = clas.primary.new()
	if clas.secondary:
		secscript = clas.secondary.new()
	if clas.passive:
		passive = clas.passive.new()
	current_spd = clas.base_spd
	current_fire_rate = clas.base_fire_cd
	current_bullet_dmg = clas.base_dmg
	current_bullet_spd = clas.base_bullet_speed
	for i in clas.upgrades:
		eq_upg(i)

func add_xp(exp):
	xp += exp
	print(xp)


func lvl_upper():
	if xp >= xp_req:
		xp = 0
		xp_req = 200 * pow(1.5, lvl)
		lvl += 1
		
		if class_chosen and not showing_upgrades:
			showing_upgrades = true
			var choices = UpgMgr.get_random_upg(3)
			upg_picker.show_upg(choices)

func lvl_milestone():
	if lvl == 1 and !class_chosen:
		class_picker.show()
		pass

func get_dmged(dmg):
	if !is_invincible:
		health -= dmg
		current_bullets = magazine
		is_invincible = true
		$Timer.start()
		if health <= 0:
			get_tree().call_deferred('reload_current_scene')

func _on_timer_timeout() -> void:
	is_invincible = false
	print('no invince')
