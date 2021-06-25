extends ApplianceBase

var bowl_inventory 
var is_open = false
var space_select = 0


func _ready():
	var bowl_spaces = $BowlSpaces.get_children()
	selector = $Selector
	ui_scale = Vector2(10, 10)
	ui_offset = Vector2(0, -5)
	set_up("Mixing Bowl", 4, {"Spot": bowl_spaces})


func use(player):
	#	Loads ingredient in the bowl
	var occupied_spaces = get_spaces("Mixing Bowl")
	var bowl_foods = get_spaces("Mixing Bowl", "Item")
	var selected_space = inv.inventory["Mixing Bowl"][ObjectUI.space_select]
	var player_item = player.held_item
	
	if ObjectUI.is_open:
		if selected_space.Item and not player.held_item:
			player.pick_up(remove_item(selected_space, "Mixing Bowl"), player.location_name(), player.hand)
			ui_interact(player)
	elif add(player, "Mixing Bowl", "add", null):
		bowl_foods = get_spaces("Mixing Bowl", "Item")
		pass
		if bowl_foods.size() == 4:
			if mix(null, false, "Mixing Bowl"):
				bowl_foods = get_spaces("Mixing Bowl", "Item")
				occupied_spaces = get_spaces("Mixing Bowl")
		
	elif not player.held_item and bowl_foods:
		player_item = remove_item(occupied_spaces[bowl_foods.size()-1], "Mixing Bowl")
		player_item.visible = true
		player.pick_up(player_item, player.location_name(), player.hand)


func remove_food(item_spot, location):
	var item = item_spot.Item
	remove_item(item_spot, location)
	return item

