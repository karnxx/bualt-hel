extends Node
var plr
func _ready() -> void:
	plr = get_parent()
	plr.upgdata['spray'] = {'bullets': 1, "cone": 3, 'fan' : 10}
