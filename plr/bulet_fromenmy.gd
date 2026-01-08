extends CharacterBody2D
var dmg
var pierce = 0

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	self.queue_free()

func shoot(plr, dir):
	dmg = plr.current_bullet_dmg
	var spd = plr.current_bullet_spd
	velocity = dir.normalized() * spd * GameManager.time_scale
	rotation = dir.angle()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method('get_dmged') and body.is_in_group('plr'):
		body.get_dmged(dmg)
		if pierce <= 0:
			self.queue_free()

func _physics_process(_delta):
	var camera = get_viewport().get_camera_2d()
	if camera:
		var cam_rect = Rect2(camera.global_position - camera.zoom * camera.get_viewport_rect().size / 2,
							 camera.zoom * camera.get_viewport_rect().size)
		$Sprite2D.visible = cam_rect.has_point(global_position)
	move_and_slide()
