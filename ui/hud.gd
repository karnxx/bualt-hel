extends Control

var plr
@onready var bullet_container = $HBoxContainer
var bullet_scene = preload("res://bulleticon.tscn")
@onready var hp: ProgressBar = $hp
var last_current := -1
var last_mag := -1

func _ready() -> void:
	plr = get_parent().get_parent()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_force_rebuild()

func _process(_delta):
	if plr.current_bullets != last_current or plr.magazine != last_mag:
		update_bullets()
	hp.max_value = plr.max_health
	hp.value = plr.health

func _force_rebuild():
	last_current = -1
	last_mag = -1
	update_bullets()

func update_bullets():
	last_current = plr.current_bullets
	last_mag = plr.magazine

	if bullet_container.get_child_count() != last_mag:
		for c in bullet_container.get_children():
			c.queue_free()
		for i in range(last_mag):
			bullet_container.add_child(bullet_scene.instantiate())

	for i in range(last_mag):
		bullet_container.get_child(i).visible = i < last_current
