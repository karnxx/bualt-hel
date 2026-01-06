extends Area2D
var plr
var health = 10

func _ready() -> void:
	plr = get_parent()
	plr.connect('plr_dmged', asd)

func asd():
	visible = true
	get_tree().create_timer(plr.upgdata['shield']['time']).timeout.connect(dda)

func dda():
	plr.is_invincible = false
	visible = false

func get_dmged(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
