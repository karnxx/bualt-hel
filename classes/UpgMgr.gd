extends Node
var plr
var upgs = [
preload("res://classes/risk/CURSE.gd"),
preload("res://classes/risk/GREED.gd"),
preload("res://classes/upgrades/BABYRAPID.gd"),
preload("res://classes/upgrades/FULLMETAL-PIERCE.gd"),
preload("res://classes/upgrades/HEALTH-HORDE.gd"),
preload("res://classes/upgrades/HEALTHMOUND.gd"),
preload("res://classes/upgrades/HEALTHPACK.gd"),
preload("res://classes/upgrades/MAG-LOAD.gd"),
preload("res://classes/upgrades/MAGAZINE.gd"),
preload("res://classes/upgrades/PIERCE-I.gd"),
preload("res://classes/upgrades/POWER-I.gd"),
preload("res://classes/upgrades/POWER-II.gd"),
preload("res://classes/upgrades/RAPID-I.gd"),
preload("res://classes/upgrades/SONIC.gd"),
preload("res://classes/upgrades/SPEEDSTER-I.gd"),
preload("res://classes/upgrades/SPEEDSTER-II.gd"),
preload("res://classes/upgrades/SPEEDSTER-III.gd"),
preload("res://classes/upgrades/VELOCITY-I.gd"),
preload("res://classes/upgrades/VELOCITY-II.gd"),
preload("res://classes/upgrades/VELOCITY-III.gd"),
preload("res://classes/upgrades/VELOCITY-IV.gd"),
preload("res://classes/upgrades/VITALITY-I.gd"),
preload("res://classes/upgrades/VITALITY-II.gd"),
preload("res://classes/upgrades/VITALITY-IIdi.gd"),
preload("res://classes/upgrades/VITALITY-III.gd"),
preload("res://classes/TIME/ACCEL-I.gd"),
preload("res://classes/TIME/DRAG-I.gd"),
preload("res://classes/SPRAY/NOZZLE.gd"),
]
var is_upging = false


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	print(get_random_upg(3))

func establish_plr(pdlr):
	plr = pdlr

func get_availed():
	var available = []

	for i in upgs:
		var scrip = i.new()
		var can_use = true

		if scrip.min_lvl > plr.lvl:
			can_use = false

		if scrip.class_req != null:
			if not plr.current_class or scrip.class_req != plr.current_class.nam:
				can_use = false

		for owned in plr.upgrades_applied:
			if owned.upg_name == scrip.upg_name:
				can_use = false
				break

		for req in scrip.requires:
			var has_req = false
			for owned in plr.upgrades_applied:
				if owned.upg_name == req:
					has_req = true
					break
			if not has_req:
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
