extends Area2D

class_name ApplianceBase

var inventory = {}
var type = "Interactable"
var in_use = false
var object
var inventory_size
var free_slots = {}
var taken_slots = {}


func set_up(location, size = -1, params = []):
	inventory_size = size
	inventory[location] = {}
	free_slots[location] = []
	taken_slots[location] = []
	
	for slot in size:
		inventory[location][slot] = {"Item": null}
		inventory[location][slot]["Slot Index"] = slot
		free_slots[location].append(slot)
		if params.size() != 0:
			for param_group in params:
				inventory[location][slot][param_group] = params[param_group][slot]
				
				pass


func pick_up(item = null, location = "Default", hand = null):
#	Check there's space in inventory
	if free_slots[location] == []:
		return false
	var chosen_slot = free_slots[location][0]
	if inventory[location][0].has("Spot") and hand:	
		for spot in free_slots[location]:
			var inventory_spot = inventory[location][spot]["Spot"]
			if inventory_spot == hand:
				var slot_index = free_slots[location].find(spot)
				chosen_slot = free_slots[location][slot_index]
				break
	item.get_parent().remove_child(item)
	taken_slots[location].append(chosen_slot)
	taken_slots[location].sort()
	free_slots[location].erase(chosen_slot)
	item.held = true
	if hand:
		item.hand = hand
		hand.add_child(item)
	else:
		item.hand = inventory[location][chosen_slot]["Spot"]
		var spot = inventory[location][chosen_slot]["Spot"]
		spot.add_child(item, true)
	item.position = Vector2(0, 0)
		
		
	inventory[location][chosen_slot]["Item"] = item
	return false


func get_slots(location, extra = null, extra2 = null, get_all = false):
	var used_slots = taken_slots[location]
	var item_array = []
	if get_all:
		for slot in inventory[location]:
			if extra:
				item_array.append(inventory[location][slot][extra])
			else:
				item_array.append(inventory[location][slot])
		return item_array
	else:
		for slot in inventory[location]:
			if extra and inventory[location][slot][extra]:
				item_array.append(inventory[location][slot][extra])
			elif used_slots and used_slots.has(slot):
				item_array.append(inventory[location][slot])
#	var used_slots = taken_slots[location]
		return item_array
		


func is_space(location):
	if free_slots[location] != []:
		return true
	else:
		return false

func ui_interact(player):
	pass

func remove_item(slot, location):
	var item = slot.Item
	var slot_number = slot["Slot Index"]
	free_slots[location].append(slot_number)
	print("Slot Number: %s" % slot_number)
	taken_slots[location].erase(slot_number)
	free_slots[location].sort()
	item.held = false
	item.hand = null
	inventory[location][slot_number]["Item"] = null
	item.get_parent().remove_child(item)
	get_node("/root/Main").add_child(item)
	return item

func delete(slot, location):
	var item = remove_item(slot, location)
	item.queue_free()
