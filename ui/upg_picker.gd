extends Control

signal chosen(upg_Script)

@onready var buttons = $VBoxContainer.get_children()
func show_upg(upg_list):
	visible = true
	
	for i in buttons.size():
		if i < upg_list.size():
			var butan = buttons[i]
			butan.setup(upg_list[i])
			butan.pressed.connect(_on_button_pressed.bind(upg_list[i]))
			butan.show()
		else:
			buttons[i].hide()

func _on_button_pressed(upg_script):
	visible = false
	emit_signal('chosen', upg_script)
