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


func pick_up(item = null, location = inv.default_location, hand = null, space = -1):
	var pick_up_state =  inv.pick_up(item, location, hand, space)
	if pick_up_state:
		pass
#		pick_up_state.Item.detect = false


func add(player, location, action, hand = null):
	return inv.add(player, location, action, hand)


func remove_item(space, location = inv.default_location, hand = null):
	var remove_item_state = inv.remove_item(space, location, hand)
	if remove_item_state:
#		remove_item_state.detect = true
		pass
#		var player = get_tree().get_nodes_in_group("Player")
#		add_child_below_node(player[0], self)
	return remove_item_state

func delete(space, location):
	return inv.delete(space, location)


func get_spaces(location = inv.default_location, extra = null, extra2 = null, get_type = "used"):
	return inv.get_spaces(location, extra, extra2, get_type)


func item_space(space_index, location = inv.default_location):
	return inv.item_space(space_index, location)

func get_location_names():
	return inv.get_location_names()

func location_name():
	return inv.location_name()


func is_space(location = inv.default_location):
	return inv.is_space(location)


func inv_size(location = inv.default_location):
	return inv.inv_size(location)

func ui_interact(player):
		ObjectUI.ui_interact(player, self, ui_scale, ui_offset, selector, anim_player, collision)
#	if not is_open:
#		is_open = true
#		player.get_node("UI/Background").visible = true
#		player.get_node("UI/LocationUI").scale = ui_scale
#		tool_location = global_position
#		get_parent().remove_child(self)
#		player.get_node("UI/LocationUI").add_child(self)
#		position = Vector2.ZERO
#		selector.visible = true
#		player.disable_input += ["Move", "Pick Up", "Drop"]
#		if anim_player:
#			anim_player.play("right")
#		modulate = Color(1, 1, 1, 1)
#		position -= Vector2(ui_offset)
#	elif is_open:
#		is_open = false
#		player.get_node("UI/Background").visible = false
#		var base_node = get_node("/root/Main")
#		get_parent().remove_child(self)
#		if player.held_item:
#			player.hand.add_child(self)
#			position = Vector2.ZERO
#		else:
#			base_node.add_child(self)
#			global_position = tool_location
#		selector.visible = false
#		player.disable_input.erase("Move")
#		player.disable_input.erase("Pick Up")
#		player.disable_input.erase("Drop")
#		player.set_direction(player.direction)
#		player.set_state("idle")


