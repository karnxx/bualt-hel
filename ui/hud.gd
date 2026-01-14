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
	rebuild()
	get_tree().create_timer(1).timeout.connect(removetext)

func removetext():
	var tween =  create_tween()
	tween.tween_property($Label3, "modulate:a", 0, 5)

func _process(_delta):
	if plr.current_bullets != last_current or plr.magazine != last_mag:
		update_bullets()
	hp.max_value = plr.max_health
	hp.value = plr.health
	$Label.text = str(plr.xp) + "/" + str(plr.xp_req)
	$Label2.text = str(plr.lvl)
	$bulala/Label.text = str(plr.current_bullets)

func rebuild():
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
