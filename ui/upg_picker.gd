extends Control

signal chosen(upg_Script)

@onready var buttons = $VBoxContainer.get_children()
func show_upg(upg_list):
	visible = true
	move_to_front()
	get_tree().paused = true
	for i in buttons.size():
		var butan = buttons[i]

		if butan.pressed.is_connected(_on_button_pressed):
			butan.pressed.disconnect(_on_button_pressed)

		if i < upg_list.size():
			butan.setup(upg_list[i])
			butan.pressed.connect(_on_button_pressed.bind(upg_list[i]))
			butan.show()
		else:
			butan.hide()


func _on_button_pressed(upg_script):
	visible = false
	emit_signal('chosen', upg_script)
