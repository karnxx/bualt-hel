extends Area2D
var plr
func _ready() -> void:
	plr = get_parent()
	plr.connect('plr_dmged', waverel)

func waverel():
	$CollisionShape2D.shape.radius = plr.upgdata['shockwave']['range']
	monitoring = true
	await get_tree().create_timer(0.2).timeout
	monitoring = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemy'):
		body.knockback(plr.global_position, plr.upgdata['shockwave']['power'])
		print(body)
