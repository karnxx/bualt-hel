extends Control
signal class_chosen(clas)

var burst_class := preload("res://classes/burst/burstclass.tres")
var spray_class := preload("res://classes/burst/burstclass.tres")
var seek_class  := preload("res://classes/burst/burstclass.tres")
var time_class  := preload("res://classes/burst/burstclass.tres")
var risk_class  := preload("res://classes/burst/burstclass.tres")

@onready var desc: Label = $VBoxContainer/Label


func _ready():
	print("burst:", burst_class)
	print("spray:", spray_class)
	print("seek:", seek_class)
	print("time:", time_class)
	print("risk:", risk_class)

	await get_tree().create_timer(1).timeout
	bind($VBoxContainer/HBoxContainer/burst, burst_class)
	bind($VBoxContainer/HBoxContainer/spray, spray_class)
	bind($VBoxContainer/HBoxContainer/seek,  seek_class)
	bind($VBoxContainer/HBoxContainer/time,  time_class)
	bind($VBoxContainer/HBoxContainer/risk,  risk_class)


func bind(btn, clas):
	var c = clas as Class
	btn.text = clas.nam
	btn.pressed.connect(func():
		emit_signal("class_chosen", c)
	)

	btn.mouse_entered.connect(func():
		desc.text = c.desc
	)
