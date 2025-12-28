extends CharacterBody2D
var dmg
var pierce = 0

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	self.queue_free()

func shoot(plr, dir):
	dmg = plr.current_bullet_dmg
	var spd = plr.current_bullet_spd
	velocity = dir.normalized() * spd
	rotation = dir.angle()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method('get_dmged') and body.is_in_group('plr'):
		body.get_dmged(dmg)
		if pierce <= 0:
			self.queue_free()

func _physics_process(_delta):
	move_and_slide()
