extends Area2D

class_name ApplianceBase

var inv = preload("res://inventory.tscn").instance()
var type = "Interactable"
var in_use = false
var detect = true
var held = false
var ui_scale = Vector2(30, 30)
var ui_offset = Vector2.ZERO
var selector
var anim_player
var collision

func _ready():
	self.add_child(inv)


func set_up(location, size = -1, params = []):
	return inv.set_up(location, size, params)


func pick_up(item = null, location = inv.default_location, hand = null, space_index = -1):
	return inv.pick_up(item, location, hand, space_index)


func add(player, location, action, hand = null):
	return inv.add(player, location, action, hand)


func remove_item(space, location = inv.default_location, hand = null):
	return inv.remove_item(space, location, hand)


func delete(space, location):
	return inv.delete(space, location)


func get_spaces(location, extra = null, extra2 = null, get_type = "used"):
	return inv.get_spaces(location, extra, extra2, get_type)


func item_space(space_index, location = inv.default_location):
	return inv.item_space(space_index, location)

func get_location_names():
	return inv.get_location_names()

func location_name():
	return inv.location_name()

func ui_interact(player):
	ObjectUI.ui_interact(player, self, ui_scale, ui_offset, selector, anim_player, collision)

func copy(space_item):
	return inv.copy(space_item)


func is_space(location = inv.default_location):
	return inv.is_space(location)


func inv_size(location = inv.default_location):
	return inv.inv_size(location)


func mix(item_tool = null, can_cook = false, location = inv.default_location):
	var object
	if item_tool:
		object = item_tool
	else:
		object = self
	
	var object_foods = object.get_spaces(location, "Item")
	var foods = ItemFood.check_recipe(object_foods, can_cook)
	if foods:
		var food_path = foods["Path"]
		var food_node = load(food_path).instance()
		var object_spaces = object.get_spaces(location)
		for space in object_spaces:
				object.delete(space, location)
				
		get_node("/root/Main").add_child(food_node)
		object.pick_up(food_node, location)
	
		return food_node
	else:
		return false

func valid_recipe(location, item_tool = null):
	var ingredients = []
	var object	
	var object_foods
	
	if item_tool:
		object = item_tool
	else:
		object = self
		
	object_foods = object.get_spaces(location, "Item")
	
	for food in object_foods.size():
		var food_state = object_foods[food].get_stats()
		ingredients.append(food_state)
	ingredients.sort()

	for food in ItemFood.food_recipes:
		var recipe = food["Recipe"]
		if ingredients.hash() == recipe.hash():
			return [food, ingredients]
	return false
