extends Area2D

class_name ApplianceBase

#var inventory = {}
var inv = preload("res://inventory.tscn").instance()
var type = "Interactable"
var in_use = false
#var object
#var inventory_size
#var free_slots = {}
#var taken_slots = {}

func _ready():
	self.add_child(inv)

func set_up(location, size = -1, params = []):
	return inv.set_up(location, size, params)
	
func pick_up(item = null, location = "Default", hand = null, slot = -1):
	return inv.pick_up(item, location, hand, slot)


func remove_item(slot, location = "Default"):
	return inv.remove_item(slot, location)


func delete(slot, location):
	return inv.delete(slot, location)


func get_slots(location, extra = null, extra2 = null, get_type = "used"):
	return inv.get_slots(location, extra, extra2, get_type)

func get_item_slot(slot_index, location = "Default"):
	return inv.get_item_slot(slot_index, location)

func copy(slot_item):
	return inv.copy(slot_item)


func is_space(location = "Default"):
	return inv.is_space(location)
#
func ui_interact(player):
	pass
#

	
func mix(location):
	var ingredients = []
	var bowl_inventory = get_slots(location, "Item")
	for food in bowl_inventory.size():
		var food_state = bowl_inventory[food].get_stats(bowl_inventory[food])
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
			for item in bowl_slots:
				delete(item, "Mixing Bowl")
				
			pick_up(food_node, "Mixing Bowl")
			return food_node
