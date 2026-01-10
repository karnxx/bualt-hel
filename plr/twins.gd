extends Node2D

var elite = false

func _process(_delta: float) -> void:
	if elite == true:
		$idkname.elite = true
		$idkname2.elite = true
