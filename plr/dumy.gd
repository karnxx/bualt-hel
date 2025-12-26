extends CharacterBody2D
var health = 2 #200
var xp_given = randi_range(400,800)
var dmg = randi_range(1,10)
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr 
var current_bullet_dmg = 10
var current_bullet_spd = 600
func get_dmged(dmg):
	health -= dmg
	if health <= 0:
		self.queue_free()
		get_parent().get_node('plr').add_xp(xp_given)

func _process(delta: float) -> void:
	plr = get_parent().get_node('plr')
	shoot()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('plr'):
		body.get_dmged(dmg)

func shoot():
	await get_tree().create_timer(1).timeout
	var origin = global_position
	var dir = (plr.global_position - origin).normalized()
	var bulat = BULET_FROMENMY.instantiate()
	bulat.global_position = origin
	self.get_parent().add_child(bulat)
	bulat.shoot(self, dir)
