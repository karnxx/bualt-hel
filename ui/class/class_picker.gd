extends Control
signal class_chosen(clas)

# Preload all classes
var burst_class := preload("res://classes/burst/burstclass.tres")
var spray_class := preload("res://classes/burst/burstclass.tres")
var seek_class  := preload("res://classes/burst/burstclass.tres")
var time_class  := preload("res://classes/burst/burstclass.tres")
var risk_class  := preload("res://classes/burst/burstclass.tres")

@onready var desc: Label = $VBoxContainer/Label
@onready var burst_btn: Button = $VBoxContainer/HBoxContainer/burst
@onready var spray_btn: Button = $VBoxContainer/HBoxContainer/spray
@onready var seek_btn: Button = $VBoxContainer/HBoxContainer/seek
@onready var time_btn: Button = $VBoxContainer/HBoxContainer/time
@onready var risk_btn: Button = $VBoxContainer/HBoxContainer/risk


func _ready():
	await get_tree().process_frame
	
	burst_btn.text = burst_class.nam
	spray_btn.text = spray_class.nam
	seek_btn.text = seek_class.nam
	time_btn.text = time_class.nam
	risk_btn.text = risk_class.nam



# BURST
func _on_burst_pressed():
	emit_signal("class_chosen", burst_class)

func _on_burst_hover():
	desc.text = burst_class.desc

# SPRAY
func _on_spray_pressed():
	emit_signal("class_chosen", spray_class)

func _on_spray_hover():
	desc.text = spray_class.desc

# SEEK
func _on_seek_pressed():
	emit_signal("class_chosen", seek_class)

func _on_seek_hover():
	desc.text = seek_class.desc

# TIME
func _on_time_pressed():
	emit_signal("class_chosen", time_class)

func _on_time_hover():
	desc.text = time_class.desc

# RISK
func _on_risk_pressed():
	emit_signal("class_chosen", risk_class)

func _on_risk_hover():
	desc.text = risk_class.desc
