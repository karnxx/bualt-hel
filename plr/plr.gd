extends CharacterBody2D

var can_shoot := true
var base_spd := 400.0
var base_bullet_dmg := 10
var base_bullet_spd := 600

var current_spd := base_spd
var current_bullet_dmg := base_bullet_dmg
var current_bullet_spd := base_bullet_spd

var upgrades_applied := []
var current_class : Class

var primscript : Script
var secscript :Script
var passive :Script

func _physics_process(_delta):
	var mouse_pos := get_viewport().get_mouse_position()
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction.length() > 0:
		direction = direction.normalized()
	
	velocity = direction * current_spd
	
	move_and_slide()

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
