extends StaticBody2D

var type = "Interactable"
var bowl_inventory = []
var board_held_item


func use(player):
	var player_to_bowl = player.global_position.distance_to($DetectorBowl.global_position)
	var player_to_board = player.global_position.distance_to($DetectorBoard.global_position)
	
	if player_to_bowl > player_to_board:
		if player.held_item and not board_held_item:
			if player.held_item.is_in_group("Food"):
				var held_item = player.remove_item()
				pick_up(held_item, "board")
		elif not player.held_item and board_held_item:
			if not board_held_item.cut:
				board_held_item.cut()
			else:
				player.pick_up(remove_item(board_held_item, "board"))
	else:
		if player.held_item and bowl_inventory.size() != 4:
			if player.held_item.is_in_group("Food") and not bowl_inventory.has(player.held_item):
				var held_item = player.remove_item()
				pick_up(held_item, "bowl")
				held_item.visible = false
				if bowl_inventory.size() == 4:
					mix()
		elif not player.held_item and bowl_inventory != []:
			bowl_inventory[-1].visible = true
			player.pick_up(remove_item(bowl_inventory[-1], "bowl"))
		
	
		
	
func pick_up(item, action):
	item.held = true	
	if action == "board":
		board_held_item = item
		item.hand = get_node("CuttingBoard")
	elif action == "bowl":
		bowl_inventory.append(item)
		item.hand = get_node(".")

func remove_item(item, action):
	item.held = false
	item.hand = null
	if action == "board":
		board_held_item = null
	elif action == "bowl":
		bowl_inventory.erase(item)
	return item

func mix():
	var ingredients = []
	for food in bowl_inventory.size():
		ingredients.append(bowl_inventory[food].food_name)
	ingredients.sort()
	
	for food in ItemFood.food_recipes.size():
		var recipe = ItemFood.food_recipes[food]["Recipe"]
		var food_path = ItemFood.food_recipes[food]["Path"]
		
		var scene = load(food_path)
		var food_node = scene.instance()
		get_node("/root/Main").add_child(food_node)

		if ingredients.hash() == recipe.hash():
			for item in bowl_inventory:
				item.queue_free()
			bowl_inventory.clear()
			bowl_inventory.append(food_node)
			return
		
		
