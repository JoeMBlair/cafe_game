extends ApplianceBase

var bowl_inventory 
var board_inventory
var is_open = false
var space_select = 0

func _ready():
#	object = self
	$CanvasLayer/Bowl.visible = false
	var bowl_slots = $CanvasLayer/Bowl/FoodSlots.get_children()	
	set_up("Cutting Board", 1)
	set_up("Mixing Bowl", 4, {"Spot": bowl_slots})
	

func _process(delta):
	if is_open:
		$CanvasLayer/Bowl/Select.global_position = inv.inventory["Mixing Bowl"][space_select]["Spot"].global_position
		get_input()

func get_input():
		if Input.is_action_just_pressed("move_right"):
				if space_select < 3:
					space_select += 1
		if Input.is_action_just_pressed("move_left"):
				if space_select > 0:
					space_select -= 1
		if Input.is_action_just_pressed("move_down"):
				if space_select + 2 < 4:
					space_select += 2
		if Input.is_action_just_pressed("move_up"):
				if space_select - 2 >= 0:
					space_select -= 2


func use(player):
	var player_to_bowl = player.global_position.distance_to($DetectorBowl.global_position)
	var player_to_board = player.global_position.distance_to($DetectorBoard.global_position)
	var item = player.held_item
	

	if player_to_bowl > player_to_board:
		var board_item = get_slots("Cutting Board", "Item")
		if add(player, "Cutting Board", "cut", $CuttingBoard):
			board_item = get_slots("Cutting Board", "Item")
			return
			#	Checks if you can cut the ingredient if true then it cuts it up
		elif not player.held_item and board_item.size() != 0:
			if not board_item[0].cut:
				board_item[0].cut()
			else:
				var board_slot = get_slots("Cutting Board")
				board_slot = board_slot[0]
				player.pick_up(remove_item(board_slot, "Cutting Board"), "Default", player.hand)
	else:
#		Loads ingredient in the bowl
		var occupied_slots = get_slots("Mixing Bowl")
		var bowl_foods = get_slots("Mixing Bowl", "Item")
		var selected_slot = inv.inventory["Mixing Bowl"][space_select]
		if is_open:
			if selected_slot.Item and not player.held_item:
#				selected_slot.Item.scale = Vector2(1, 1)
				player.pick_up(remove_item(selected_slot, "Mixing Bowl"), "Default", player.hand)
				ui_interact(player)
		elif add(player, "Mixing Bowl", "add", null, 5):
			bowl_foods = get_slots("Mixing Bowl", "Item")
			pass
			if bowl_foods.size() == 4:
				mix("Mixing Bowl")
				bowl_foods = get_slots("Mixing Bowl", "Item")
				occupied_slots = get_slots("Mixing Bowl")
			
		elif not player.held_item and bowl_foods:
			item = remove_item(occupied_slots[bowl_foods.size()-1], "Mixing Bowl")
			item.visible = true
#			item.scale = Vector2(1, 1)
			player.pick_up(item, "Default", player.hand)


func add(player, location, action, hand = null, scale = 1):
	if not is_space(location):
		return false
	var item = player.held_item
	var slot = player.held_slot
	if not item:
		return false
	if item.valid_item(item, location, action):
		var player_food = player.remove_item(slot)
		pick_up(player_food, location, hand)
#		item.scale = Vector2(scale, scale)
		return true
	return false


#func mix():
#	var ingredients = []
#	var bowl_inventory = get_slots("Mixing Bowl", "Item")
#	for food in bowl_inventory.size():
#		var food_state = bowl_inventory[food].get_stats(bowl_inventory[food])
#		ingredients.append(food_state)
#	ingredients.sort()
#
#	for food in ItemFood.food_recipes.size():
#		var recipe = ItemFood.food_recipes[food]["Recipe"]
#		var food_path = ItemFood.food_recipes[food]["Path"]
#
#		var scene = load(food_path)
#		var food_node = scene.instance()
#		get_node("/root/Main").add_child(food_node)
#
#		if ingredients.hash() == recipe.hash():
#			var bowl_slots = get_slots("Mixing Bowl")
#			for item in bowl_slots:
#				delete(item, "Mixing Bowl")
#
#			pick_up(food_node, "Mixing Bowl")
#			food_node.scale = Vector2(5, 5)
#
#			return


func remove_food(item_spot, location):
	var item = item_spot.Item
	remove_item(item_spot, location)
#	item.scale = Vector2(1, 1)
	return item


func ui_interact(player):
	if not $CanvasLayer/Bowl.visible:
		$CanvasLayer/Bowl.visible = true
		player.disable_input += ["Move"]
		is_open = true
	else:
		$CanvasLayer/Bowl.visible = false
		player.disable_input.erase("Move")
		is_open = false
	pass
