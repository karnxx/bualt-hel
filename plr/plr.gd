extends CharacterBody2D

var xp = 0
var lvl = 0
var xp_req = 200 * pow(1.5, lvl)

var can_shoot := true
var base_spd := 400.0
var base_bullet_dmg := 10
var base_bullet_spd := 600

var current_spd := base_spd
var current_bullet_dmg := base_bullet_dmg
var current_bullet_spd := base_bullet_spd

var upgrades_applied := []
var current_class : Class

var primscript 
var secscript
var passive 

func _ready() -> void:
	UpgMgr.establish_plr(self)
	eq_class(preload("res://classes/basic/basic.tres"))

func _physics_process(_delta):
	#var mouse_pos := get_viewport().get_mouse_position()
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction.length() > 0:
		direction = direction.normalized()
	if Input.is_action_just_pressed("primary"):
		primary()
	if Input.is_action_just_pressed('secondary'):
		secondary()
	
	velocity = direction * current_spd
	
	move_and_slide()

func primary():
	primscript.primary(self, get_viewport().get_camera_2d().get_global_mouse_position())

func secondary():
	pass

func eq_upg(upg:Script):
	var u = upg.new()
	u.apply_upgrade(self)
	upgrades_applied.append(u)

func eq_class(clas:Class):
	current_class = clas
	if clas.primary:
		primscript = clas.primary.new()
	if clas.secondary:
		primscript = clas.secondary.new()
	if clas.passive:
		passive = clas.passive.new()
	for i in clas.upgrades:
		eq_upg(i)

func add_xp(exp):
	xp += exp
	print(xp)

func lvl_upper():
	if xp >=xp_req:
		xp = 0
		lvl +=1
	pass
