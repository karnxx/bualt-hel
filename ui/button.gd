extends Button

var upg_script

func setup(script):
	upg_script = script
	text = script.new().upg_name
	$Label.text = script.new().desc
