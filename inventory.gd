extends Node2D

class_name InventoryClass

var inventory = {}
#var type = "Interactable"
var in_use = false
var object
var inventory_size
#var free_slots = {}
#var taken_slots = {}

func _ready():
#	get_node("/root/Main").add_child(self)
	pass


func set_up(location, size = -1, params = []):
#	"Default" = location
	inventory_size = size
	inventory[location] = {}
#	free_slots[location] = []
#	taken_slots[location] = []
	
	for slot in size:
		inventory[location][slot] = {"Item": null}
		inventory[location][slot]["Slot Index"] = slot
#		free_slots[location].append(slot)
		if params.size() != 0:
			for param_group in params:
				inventory[location][slot][param_group] = params[param_group][slot]


func pick_up(item, location = "Default", hand = null, slot = -1):
	if not item:
		return false
#	if not is_space(location):
#		return false
	item.held = true
	item.position = Vector2(0, 0)	
	var item_location
	var free_slots = get_slots(location, null, null, "free")
	var chosen_slot	
	
	if free_slots.size() == 0:
		return false
	if slot != -1:
		item_location = inventory[location][slot]["Spot"]
		chosen_slot = slot
		
	elif not hand:
		item_location = free_slots[0]["Spot"]
		chosen_slot = free_slots[0]["Slot Index"]
	else:
		item_location = hand
		chosen_slot = free_slots[0]["Slot Index"]
		

	item.get_parent().remove_child(item)
	item_location.add_child(item)
	inventory[location][chosen_slot]["Item"] = item


func get_slots(location = "Default", extra = null, extra2 = null, get_type = "used"):
	var item_array = []
	for slot in inventory[location]:
		if get_type == "all":
			if extra:
				item_array.append(inventory[location][slot][extra])
			else:
				item_array.append(inventory[location][slot])
		elif get_type == "free":
			if extra and  not inventory[location][slot][extra]:
				item_array.append(inventory[location][slot][extra])
			elif not inventory[location][slot]["Item"]:
				item_array.append(inventory[location][slot])
		elif get_type == "used":
			if extra and inventory[location][slot][extra]:
				item_array.append(inventory[location][slot][extra])
			elif inventory[location][slot]["Item"]:
				item_array.append(inventory[location][slot])
	if item_array.size() == 0:
		return []
#	item_array.sort()
	return item_array


func get_item_slot(slot_index = -1, location = "Default"):
	return inventory[location][slot_index]


func is_space(location = "Default"):
	for slot in inventory[location]:
		if not inventory[location][slot]["Item"]:
			return true
	return false

func copy(slot_item):
	pass
	var item_path = slot_item.filename
	var scene = load(item_path)
	var item_copy = scene.instance()
	item_copy.set_vars(slot_item)
	get_node("/root/Main").add_child(item_copy)
	return item_copy

func remove_item(slot, location = "Default"):
	var item = slot.Item
	item.held = false
	var drop_location = item.global_position
	var slot_index = slot["Slot Index"]
	inventory[location][slot_index]["Item"] = null
	item.get_parent().remove_child(item)
	get_node("/root/Main").add_child(item)
	item.global_position = drop_location
	return item


func has_item(item, location = "Default"):
	for inv_item in inventory[location]:
		if inv_item.Item == item:
			return inventory[location][inv_item["Slot Index"]]
	return false


func delete(slot, location = "Default"):
	var item = remove_item(slot, location)
	item.queue_free()
