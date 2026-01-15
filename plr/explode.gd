extends Area2D

var plr
var multiplier := 1.0
var chch := 0
var max_chain := 5
var decay := 0.2
var used := false

func _ready() -> void:
	plr = get_parent().get_node("plr")
	var r = plr.upgdata["fuse"]["radius"]
	$CollisionShape2D.shape.radius = r
	$Sprite2D.scale = Vector2(r / 100.0, r / 100.0)
	await get_tree().create_timer(0.05).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if used or !body.is_in_group("enemy"):
		return
	used = true
	body.get_dmged(plr.upgdata["fuse"]["dmg"] * multiplier)
	body.knockback(global_position, 100)
	call_deferred('asd', body)

func asd(body):
	if plr.upgdata["fuse"]["chain"] and chch < max_chain:
		var e = preload("res://plr/explode.tscn").instantiate()
		e.global_position = body.global_position
		e.chch = chch + 1
		e.multiplier = multiplier * decay
		get_parent().add_child(e)
