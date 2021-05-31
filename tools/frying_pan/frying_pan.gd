extends ToolBase

var pan_inventory

func _ready():
#	set_item(self)
	var food_spots = $FoodSpots.get_children()
	set_up("Frying Pan", 4, {"Spot": food_spots})
	item_name = "Frying Pan"
	item_type = "tool"
	valid_slots += ["Hob"]
	pan_inventory = inventory["Frying Pan"]
	
func use(player):
	var item = player.held_item
	pan_inventory = inventory["Frying Pan"]	
	var pan_foods = get_slots("Frying Pan")	
	if player.held_item:
		if pan_foods.size() <= 4 and pan_foods.size() > 0 and player.held_item.item_name == "Frying Pan":
			remove_item(pan_foods[-1], "Frying Pan")
			return
	if add(player, 4, "Frying Pan", "add", self):
		pass
	else:
		return false
#	if not player.pick_ups == []:
#		player.nearest_action(player.pick_ups)
#	player.modulate = Color(1,1,0)


func add(player, capacity, location, action, hand):
	if not player.held_item:
		return false
	var item = player.held_item
	if item.valid_item(item, location, action):
		var player_food = player.remove_item()
		pick_up(player_food, location)
		return true
	return false

