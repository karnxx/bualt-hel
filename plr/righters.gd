extends CharacterBody2D
var health = 20
var xp_given = randi_range(100,200) * GameManager.global_loot_mult
var dmg = randi_range(1,10) * GameManager.global_enemy_dmg_scale
const BULET_FROMENMY = preload("res://plr/bulet_fromenmy.tscn")
var plr 
var current_bullet_dmg = 10
var current_bullet_spd = 600
var speed = 600
var pathfind = true
var dirs = [Vector2.UP,Vector2.RIGHT,Vector2.LEFT,Vector2.DOWN]
var dir1 = dirs.pick_random()
var dir2 = dirs.pick_random()
var dir3 = dirs.pick_random()
var can_shot = true

var elite = false

func _ready() -> void:
	$Timer.start()
	if elite:
		$Sprite2D.scale = 2
		$Sprite2D.modulate = Color.WEB_PURPLE
		$CollisionShape2D.scale = 2

func get_dmged(dtmg):
	health -= dtmg
	if health <= 0:
		self.queue_free()
		get_parent().get_node('plr').add_xp(xp_given)

func _physics_process(_delta: float) -> void:
	if pathfind:
		shoot()
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('plr'):
		body.get_dmged(dmg)
		pathfind = false

func shoot():
	if !can_shot:
		return
	if dir1 == dir2:
		dir2 = dirs.pick_random()
		if elite:
			if dir3 == dir1 or dir3 == dir2:
				dir3 = dirs.pick_random()
	var dirars = [dir1, dir2]
	var bulat = BULET_FROMENMY.instantiate()
	var bulat2 = BULET_FROMENMY.instantiate()
	if elite:
		var bulat3 = BULET_FROMENMY.instantiate()
		bulat3.global_position = global_position
		get_parent().add_child(bulat3)
		bulat3.shoot(self, dir3)
	bulat.global_position = global_position
	bulat2.global_position = global_position
	get_parent().add_child(bulat)
	get_parent().add_child(bulat2)
	bulat.shoot(self, dir1)
	bulat2.shoot(self, dir2)
	can_shot = false
	await get_tree().create_timer(1).timeout
	can_shot = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('plr'):
		await get_tree().create_timer(1).timeout
		pathfind = true


func _on_timer_timeout() -> void:
	dir1 = dirs.pick_random()
	dir2 = dirs.pick_random()
	if elite:
		dir3.pick_random()
	$Timer.start()
