extends CharacterBody2D

@export var sped := 400.0
var can_shoot := true
func _physics_process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction.length() > 0:
		direction = direction.normalized()
	
	velocity = direction * sped
	
	move_and_slide()
