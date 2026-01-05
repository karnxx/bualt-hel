extends Area2D

func _ready() -> void:
	monitoring = true
	await get_tree().create_timer(0.2).timeout
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemy'):
			body.get_dmged(5)
			body.knockback(global_position, 700)
			print('asd')
