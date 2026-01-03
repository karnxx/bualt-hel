extends Area2D
var plr
func _ready() -> void:
	plr = get_parent()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemy'):
		body.get_dmged(plr.upgdata['thorns']['dmg'])
