extends Area2D

func _ready() -> void:
	monitoring = true
	var bodies = get_overlapping_bodies()
	for i in bodies:
		if i.is_in_group('enemy'):
			i.get_dmged(5)
			i.knockback(global_position, 500)
	await get_tree().create_timer(0.2).timeout
	queue_free()
