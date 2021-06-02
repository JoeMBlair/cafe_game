extends ToolBase

#var pan_inventory

func _ready():
#	set_item(self)
	var food_spots = $FoodSpots.get_children()
	set_up("Default", 4, {"Spot": food_spots})
	item_name = "Frying Pan"
	item_type = "tool"
	valid_slots += ["Hob"]
#	pan_inventory = inventory["Frying Pan"]


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



func cook():
	var ingredients = []
	var pan_inventory = get_slots()
	for food in pan_inventory.size():
		var food_state = pan_inventory[food].get_stats(pan_inventory[food])
		ingredients.append(food_state)
	ingredients.sort()
	
	for food in ItemFood.food_recipes.size():
		var recipe = ItemFood.food_recipes[food]["Recipe"]
		var food_path = ItemFood.food_recipes[food]["Path"]
		
		var scene = load(food_path)
		var food_node = scene.instance()
		get_node("/root/Main").add_child(food_node)

		if ingredients.hash() == recipe.hash():
			var bowl_slots = get_slots("Mixing Bowl")
			for slot in bowl_slots:
				delete(slot, "Mixing Bowl")
				
			pick_up(food_node, "Mixing Bowl")
			food_node.scale = Vector2(5, 5)



func add(player, location, action, hand = null):
	if not player.held_item:
		return false
	var held_item = player.held_item
	if held_item.valid_item(held_item, location, action):
		var player_food = player.remove_item(player.held_slot)
		pick_up(player_food)
		return true
	return false

