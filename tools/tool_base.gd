extends ItemBase

class_name ToolBase

var glo_pos
var is_open = false
var space_select = 0
var inv = preload("res://inventory.gd").new()

func _ready():
	$AnimatedSprite.add_child(inv)

func _process(_delta):
	glo_pos = self.global_position


func set_up(location, size = -1, params = []):
	return inv.set_up(location, size, params)


func pick_up(item = null, location = inv.default_location, hand = null, space = -1):
	return inv.pick_up(item, location, hand, space)


func add(player, location, action, hand = null):
	return inv.add(player, location, action, hand)


func remove_item(space, location = inv.default_location, hand = null):
	return inv.remove_item(space, location, hand)


func delete(space, location):
	return inv.delete(space, location)


func get_spaces(location = inv.default_location, extra = null, extra2 = null, get_type = "used"):
	return inv.get_spaces(location, extra, extra2, get_type)


func item_space(space_index, location = inv.default_location):
	return inv.item_space(space_index, location)


func location_name():
	return inv.location_name()


func is_space(location):
	return inv.is_space(location)


func inv_size(location = inv.default_location):
	return inv.inv_size

func ui_interact(player):
	if not is_open:
		self.scale = Vector2(8, 8)
		is_open = true
		$Select.visible = true
		player.disable_input += ["Move", "Pick Up"]
	elif is_open:
		self.scale = Vector2(1, 1)
		is_open = false
		$Select.visible = false
		player.disable_input.erase("Move")
		player.disable_input.erase("Pick Up")

