extends CharacterBody2D
var dmg
func shoot(plr, dir):
	dmg = plr.current_bullet_dmg
	var spd = plr.current_bullet_spd
	velocity = dir.normalized() * spd
	rotation = dir.angle()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method('get_dmge'):
		body.get_dmged(dmg)
func _physics_process(delta):
	move_and_slide()
