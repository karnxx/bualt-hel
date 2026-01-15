extends Area2D
var plr
func _ready() -> void:
	monitoring = true
	plr = get_parent().get_node('plr')
	$CollisionShape2D.shape.radius = plr.upgdata['fuse']['radius']
	$Sprite2D.scale = Vector2(plr.upgdata['fuse']['radius']/100,plr.upgdata['fuse']['radius']/100)
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemy'):
			body.get_dmged(plr.upgdata['fuse']['dmg'])
			body.knockback(global_position, 700)
