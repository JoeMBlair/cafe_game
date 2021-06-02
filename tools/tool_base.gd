extends ItemBase

class_name ToolBase

#var inventory = {}
var glo_pos
var is_open = false
var space_select = 0
var inv = preload("res://inventory.gd").new()

func _ready():
	$AnimatedSprite.add_child(inv)

func _process(_delta):
	glo_pos = self.global_position
	if is_open:
		var selected_spot = get_item_slot(space_select)
		$Select.global_position = selected_spot.Spot.global_position
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


func set_up(location, size = -1, params = []):
	return inv.set_up(location, size, params)


func pick_up(item = null, location = "Default", hand = null, slot = -1):
	return inv.pick_up(item, location, hand, slot)


func remove_item(slot, location = "Default"):
	return inv.remove_item(slot, location)


func delete(slot, location):
	return inv.delete(slot, location)


func get_slots(location = "Default", extra = null, extra2 = null, get_type = "used"):
	return inv.get_slots(location, extra, extra2, get_type)


func get_item_slot(slot_index, location = "Default"):
	return inv.get_item_slot(slot_index, location)


func is_space(location):
	return inv.is_space(location)


#func set_up(location, size = -1, params = []):
#	inventory[location] = {}
#
#	for slot in size:
#		inventory[location][slot] = {"Item": null}
#		inventory[location][slot]["Slot Index"] = slot
#		if params.size() != 0:
#			for param_group in params:
#				inventory[location][slot][param_group] = params[param_group][slot]
#
#
#func pick_up(item, location, hand = null):
#	item.held = true
#	var item_location
#	var free_slots = get_slots(location, null, null, "free")
#	var chosen_slot
#	item.position = Vector2(0, 0)
##	item.hand = hand
#	if not hand:
#		item_location = free_slots[0]["Spot"]
#	else:
#		item_location = hand
#
#	chosen_slot = free_slots[0]["Slot Index"]
#	item.get_parent().remove_child(item)
#	item_location.add_child(item)
#	inventory[location][chosen_slot]["Item"] = item
#
#
func ui_interact(player):
	if not is_open:
		self.scale = Vector2(8, 8)
		is_open = true
		$Select.visible = true
		player.disable_input += ["Move"]
	elif is_open:
		self.scale = Vector2(1, 1)
		is_open = false
		$Select.visible = false
		player.disable_input.erase("Move")
#
#
#func get_slots(location, extra = null, extra2 = null, type = "used"):
#	var item_array = []
#	for slot in inventory[location]:
#		if type == "all":
#			if extra:
#				item_array.append(inventory[location][slot][extra])
#			else:
#				item_array.append(inventory[location][slot])
#		elif type == "free":
#			if extra and  not inventory[location][slot][extra]:
#				item_array.append(inventory[location][slot][extra])
#			elif not inventory[location][slot]["Item"]:
#				item_array.append(inventory[location][slot])
#		elif type == "used":
#			if extra and inventory[location][slot][extra]:
#				item_array.append(inventory[location][slot][extra])
#			elif inventory[location][slot]["Item"]:
#				item_array.append(inventory[location][slot])
#	if item_array.size() == 0:
#		return []
#	item_array.sort()
#	return item_array
#
#func add_slot():
#	pass
#
#func remove_item(slot, location):
#	var item = slot.Item
#	item.held = false
#	var drop_location = item.global_position
#	var slot_index = slot["Slot Index"]
#	inventory[location][slot_index]["Item"] = null
#	item.get_parent().remove_child(item)
#	get_node("/root/Main").add_child(item)
#	item.global_position = drop_location	
#	return item


