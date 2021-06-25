extends ItemBase

class_name ToolBase

var glo_pos
var is_open = false
var space_select = 0
var inv = preload("res://inventory.tscn").instance()
var selector
var collision
var anim_player
var tool_object
var ui_location
var ui_offset = Vector2.ZERO
var tool_location
var ui_scale = Vector2(15, 15)


func _ready():
	self.add_child(inv)
	has_ui = true


func _process(_delta):
	glo_pos = self.global_position
	if is_open:
		get_input()
		var selected_spot = item_space(space_select)
		selector.global_position = selected_spot.Spot.global_position


func get_input():
	if Input.is_action_just_pressed("move_right"):
		if space_select < inv_size() - 1:
			space_select += 1
		elif space_select == inv_size() - 1:
			space_select = 0
	if Input.is_action_just_pressed("move_left"):
		if space_select > 0:
			space_select -= 1
		elif space_select == 0:
			space_select = inv_size() - 1


func set_up(location, size = -1, params = []):
	return inv.set_up(location, size, params)


func add(player, location, action, hand = null):
	return inv.add(player, location, action, hand)


func pick_up(item = null, location = inv.default_location, hand = null, space = -1):
	var pick_up_state =  inv.pick_up(item, location, hand, space)
	if pick_up_state:
		pass


func copy(space_item):
	return inv.copy(space_item)


func remove_item(space, location = inv.default_location, hand = null):
	var remove_item_state = inv.remove_item(space, location, hand)
	if remove_item_state:
#		remove_item_state.detect = true
		pass
#		var player = get_tree().get_nodes_in_group("Player")
#		add_child_below_node(player[0], self)
	return remove_item_state


func delete(space, location = inv.default_location):
	return inv.delete(space, location)


func get_spaces(location = inv.default_location, extra = null, extra2 = null, get_type = "used"):
	return inv.get_spaces(location, extra, extra2, get_type)


func get_space(item, location = inv.default_location):
	return inv.get_space(item, location)


func item_space(space_index, location = inv.default_location):
	return inv.item_space(space_index, location)


func is_space(location = inv.default_location):
	return inv.is_space(location)


func has_item(item, location = inv.default_location):
	return inv.has_item(item, location)


func inv_size(location = inv.default_location):
	return inv.inv_size(location)


func get_location_names():
	return inv.get_location_names()


func location_name():
	return inv.location_name()


func ui_interact(player):
		ObjectUI.ui_interact(player, self, ui_scale, ui_offset, selector, anim_player, collision)
