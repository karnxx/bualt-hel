extends Node


var charging := false
var charge_time := 1.0
var timer := 0.0
var player_ref

func secondary(player, target_pos):
	player_ref = player
	if not charging:
		charging = true
		timer = 0.0
		player.set_process(true)

func _process(delta):
	if charging:
		timer += delta
		if timer >= charge_time:
			_release_overcharge()

func _release_overcharge():
	if player_ref:
		var bulat = preload("res://plr/bulet.tscn").instantiate()
		bulat.global_position = player_ref.global_position
		bulat.direction = (get_viewport().get_mouse_position() - player_ref.global_position).normalized()
		bulat.damage = player_ref.current_bullet_dmg * 3
		bulat.speed = player_ref.current_bullet_spd * 1.2
		#bulat.piercing = true
		bulat.get_parent().add_child(bulat)
	charging = false
	timer = 0.0
