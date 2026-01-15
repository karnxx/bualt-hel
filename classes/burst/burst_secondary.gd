extends Node

const MAX_CHARGE := 2.0

var charging := false
var timer := 0.0
var plr
var can_timer := false

var current_bullet_dmg
var current_bullet_spd

var plr_spd
func secondary_pressed(p):
	if charging:
		return
	plr = p
	charging = true
	can_timer = true
	current_bullet_dmg = plr.current_bullet_dmg
	current_bullet_spd = plr.current_bullet_spd
	plr_spd = plr.current_spd

func secondary_released():
	if not charging:
		return
	release()
	charging = false

func _process(delta):
	if not can_timer:
		return
	if charging:
		plr.current_spd =200
	timer += delta
	if timer >= MAX_CHARGE:
		release()

func release():
	if not charging:
		return
	fire()
	charging = false
	can_timer = false
	timer = 0.0
	plr.current_spd = plr_spd
	get_tree().create_timer(10).timeout.connect(doneeee)

func doneeee():
	plr.can_secondary = true

func fire():
	var ratio = clamp(timer / MAX_CHARGE, 0.0, 1.0)
	for i in range(plr.upgdata['burst']['bullets']):
		var bulat = plr.bulet.instantiate()
		bulat.global_position = plr.get_node('pivot/gun/origin').global_position
		var dir = (plr.get_global_mouse_position() - bulat.global_position).normalized()
		plr.get_parent().add_child(bulat)

		var s = lerp(1.0, 2.0, ratio)/5

		bulat.get_node("Sprite2D").scale = Vector2.ONE  * s
		bulat.get_node("CollisionShape2D").scale = Vector2.ONE  *  s
		bulat.get_node("Area2D/CollisionShape2D2").scale = Vector2.ONE  *  s
		bulat.pierce = plr.pierce + plr.lvl
		current_bullet_dmg = current_bullet_dmg + current_bullet_dmg * lerp(0.0, 2.0, ratio)
		bulat.shoot(self, dir, plr)
		await get_tree().create_timer(0.1).timeout
	if plr.upgdata['burst']['smallers'] > 0:
		for i in range(plr.upgdata['burst']['smallers']):
			var bulat = plr.bulet.instantiate()
			bulat.global_position = plr.get_node('pivot/gun/origin').global_position
			var dir = (plr.get_global_mouse_position() - bulat.global_position).normalized()
			plr.get_parent().add_child(bulat)
			bulat.get_node("Sprite2D").scale *=  0.8
			bulat.get_node("CollisionShape2D").scale *=   0.8
			bulat.get_node("Area2D/CollisionShape2D2").scale *=  0.8
			bulat.shoot(self, dir, plr)
			bulat.dmg = current_bullet_dmg/3
			bulat.spd = current_bullet_spd/2
			await get_tree().create_timer(0.1).timeout
	
	plr.current_bullets -= 1
