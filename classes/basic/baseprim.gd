extends Node

func primary(plr):
	var origin = plr.global_position
	var mouse = get_viewport().get_mouse_position()
	var dir = (mouse-origin).normalised()
	pass
