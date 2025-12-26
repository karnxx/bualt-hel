extends Node
var plr
var upgs = [
	preload("res://classes/upgrades/SPEEDSTER-I.gd"),
	preload("res://classes/upgrades/SPEEDSTER-II.gd")
]

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	print(get_random_upg(3))

func establish_plr(pdlr):
	plr = pdlr

func get_availed():
	var available = []
	for i in upgs:
		var can_use = true
		var scrip = i.new()
		if scrip.min_lvl > plr.lvl:
			can_use = false
		for j in plr.upgrades_applied:
			if scrip.upg_name == j.upg_name:
				can_use = false
				break
		
		if can_use:
			available.append(i)
	return available

func pick_filtered(selection):
	var total_weight = 0
	
	for i in selection:
		var scrip = i.new()
		total_weight += scrip.weight
	
	var random = randi() % total_weight
	var acc = 0
	for i in selection:
		var scrip = i.new()
		acc += scrip.weight
		if random < acc:
			return i
	return selection[0]

func get_random_upg(count):
	var availables = get_availed()
	var result = []
	for i in count:
		if availables.is_empty():
			break
		var picked = pick_filtered(availables)
		result.append(picked)
		availables.erase(picked)
	
	return result
