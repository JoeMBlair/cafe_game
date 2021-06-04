extends ToolBase

func _ready():
	set_item(self)
#	var food_spots = $FoodSpots.get_children()
	set_up("Plate", 1)
	item_name = "Plate"
	item_type = "tool"
	valid_slots += ["Table"]
	
func use(player):
	var held_item = player.held_item
#	pan_inventory = inventory["Frying Pan"]	
	var pan_foods = get_slots()	
	if held_item:
		if held_item.item_name == "Frying Pan":
			if is_open:
				var food_slot = get_item_slot(space_select)
				if food_slot["Item"]:
					remove_item(food_slot)
				return
			elif pan_foods.size() <= 4 and pan_foods.size() > 0:
				remove_item(pan_foods[-1])
				return
	if add(player, "Frying Pan", "add"):
		pass
	else:
		return false
		
func add(player, "Plate", "add"):
	pass
