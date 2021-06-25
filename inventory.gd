extends Node2D

class_name InventoryClass

var inventory : Dictionary = {}
var object : Node
var default_location : String


func _ready():
	pass


func set_up(location, size = -1, params = []):
	default_location = location
	inventory[location] = {}
	
	for space in size:
		inventory[location][space] = {"Item": null}
		inventory[location][space]["Space Index"] = space
		inventory[location][space].ItemName = "null"
		if params.size() != 0:
			for param_group in params:
				inventory[location][space][param_group] = params[param_group][space]


func add(player, location, action, hand):
	if not is_space(location):
		return false
	if not player.held_item:
		return false
	var player_item = player.held_item
	if player_item.valid_item(location, action):
		var player_food = player.remove_item(player.held_space)
		pick_up(player_food, location, hand)
		return player_food
	return false


func pick_up(item, location = default_location, hand = null, space_index = -1):
	if not is_space(location):
		return false
	if not item:
		return false
	item.held = true
	item.detect = false
	item.position = Vector2(0, 0)	
	var item_location
	var free_spaces = get_spaces(location, null, null, "free")
	var chosen_index
	
#	Checks if there's space in inventory
	if free_spaces.size() == 0:
		return false
#	If index is specified then get parent of space
	if space_index != -1:
		item_location = inventory[location][space_index]["Spot"]
		chosen_index = space_index
		
#	If hand isn't specified then set space to 
	elif not hand:
		if free_spaces[0].has("Spot"):
			item_location = free_spaces[0]["Spot"]
		else:
			item_location = self
		chosen_index = free_spaces[0]["Space Index"]
	else:
		item_location = hand
		chosen_index = free_spaces[0]["Space Index"]
		
	item.get_parent().remove_child(item)
	item_location.add_child(item)
	inventory[location][chosen_index]["Item"] = item
	inventory[location][chosen_index]["ItemName"] = item.item_name
	
	return inventory[location][chosen_index]


func copy(space_item):
	var item_path = space_item.filename
	var item_copy = load(item_path).instance()
	item_copy.set_vars(space_item)
	get_node("/root/Main").add_child(item_copy)
	return item_copy


func remove_item(space, location = default_location, hand = null):
	var item = space.Item
	var drop_location
	item.held = false
	item.detect = true
	if hand:
		randomize()
		drop_location = hand.global_position
		drop_location.x += rand_range(-20, 20)
		drop_location.y += rand_range(-20, 20)
	else:
		drop_location = item.global_position
	var space_index = space["Space Index"]
	inventory[location][space_index]["Item"] = null
	inventory[location][space_index]["ItemName"] = "null"
	
	item.get_parent().remove_child(item)
	get_node("/root/Main").add_child(item)
	item.global_position = drop_location
	return item


func delete(space, location = default_location):
	var item = remove_item(space, location)
	item.queue_free()


func get_spaces(location = default_location, extra = null, _extra2 = null, get_type = "used"):
	var item_array = []
	for space in inventory[location]:
		match get_type:
			"all":
				if extra:
					item_array.append(inventory[location][space][extra])
				else:
					item_array.append(inventory[location][space])
			"free":
				if extra and  not inventory[location][space][extra]:
					item_array.append(inventory[location][space][extra])
				elif not inventory[location][space]["Item"]:
					item_array.append(inventory[location][space])
			"used":
				if extra and inventory[location][space][extra]:
					item_array.append(inventory[location][space][extra])
				elif inventory[location][space]["Item"]:
					item_array.append(inventory[location][space])
					
	if item_array.size() == 0:
		return []
	return item_array


func get_space(item, location = default_location):
	var used_spaces = get_spaces(location)
	for space in used_spaces:
		if item is String:
			if space.Item.item_name == item:
				return space
		else:
			if space.Item == item:
				return space
	return false


func item_space(space_index = -1, location = default_location):
	if space_index == -1:
		print("item_space func: no index set for %s" % location)
		return false
	return inventory[location][space_index]


func is_space(location = default_location):
	for space in inventory[location]:
		if not inventory[location][space]["Item"]:
			return true
	return false


func has_item(item, location = default_location):
	for inv_item in inventory[location]:
		if inv_item.Item == item:
			return inventory[location][inv_item["space Index"]]
	return false


func inv_size(location = default_location):
	return inventory[location].size()


func get_location_names():
	return inventory.keys()


func location_name():
	return default_location



