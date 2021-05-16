extends StaticBody2D

var type = "Interactable"
var inventory = []
func use(player):
	
	if player.held_item and inventory.size() != 4:
		if player.held_item.is_in_group("Food") and not inventory.has(player.held_item):
			var held_item = player.remove_item()
			pick_up(held_item)
			held_item.visible = false
			if inventory.size() == 4:
				mix()
	elif not player.held_item and inventory != []:
		inventory[-1].visible = true
		player.actions.erase(inventory[-1])
		player.pick_up(remove_item(inventory[-1]))
		
	
		
	
func pick_up(item):
	inventory.append(item)
	item.held = true
	item.hand = get_node(".")
	item.player = self


func remove_item(item):
	item.held = false
	item.hand = null
	inventory.erase(item)
	return item

func mix():
	for item in ItemFood.cooked_foods:
		var scene = load(item)
		
		var cake = scene.instance()
		get_node("/root/Main/Objects/Kitchen").add_child(cake)
		var ingredients = []
		for food in inventory.size():
			ingredients.append(inventory[food].food_name)
		
		ingredients.sort()
		if ingredients.hash() == cake.recipe.hash():
			for food in inventory:
				food.queue_free()
			inventory.clear()
			inventory.append(cake)
		pass
