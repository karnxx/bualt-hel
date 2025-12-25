extends CharacterBody2D
var health = 100
var xp_given = randi_range(100,200)

func get_dmged(dmg):
	health -= dmg
	if health <= 0:
		self.queue_free()
		get_parent().get_node('plr').add_xp(xp_given)
