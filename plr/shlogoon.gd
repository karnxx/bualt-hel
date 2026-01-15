extends StaticBody2D
var rand
signal died(who)
const JACK_SOUNDS = [
preload("res://assets/plr/shlogooner/increaseaudio/jack1 (mp3cut.net).mp3"), preload("res://assets/plr/shlogooner/increaseaudio/jack2 (mp3cut.net).mp3"), preload("res://assets/plr/shlogooner/increaseaudio/jack3 (mp3cut.net).mp3"), preload("res://assets/plr/shlogooner/increaseaudio/jack4 (mp3cut.net).mp3"), preload("res://assets/plr/shlogooner/increaseaudio/jack5 (mp3cut.net).mp3"), preload("res://assets/plr/shlogooner/increaseaudio/jack6 (mp3cut.net).mp3")
]
func _ready() -> void:
	randoma()

func get_dmged(_Dmg):
	sound()

func sound():
	var sound = JACK_SOUNDS.pick_random()
	$AudioStreamPlayer2D.stream = sound
	$AudioStreamPlayer2D.play()
	randoma()

func knockback(_a,_b):
	pass

func randoma():
	rand = randi()
	if rand % 2 == 0:
		$Deepfried1768405469836.visible = true
		$Deepfried1768405484777.visible = false
	else:
		$Deepfried1768405484777.visible = true
		$Deepfried1768405469836.visible = false
