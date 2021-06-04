extends ApplianceBase

var is_open = false
var space_select = 0
export var infinite = true
var just_opened = false

func _ready():
	var shelf_spots = $CanvasLayer/Shelf/ShelfSpaces.get_children()	
	set_up("Fridge", shelf_spots.size(), {"Spot": shelf_spots})
	$CanvasLayer/Shelf.visible = false

	for space in get_spaces("Fridge", "Spot", null, "all"):
		var items = space.get_children()
		if items.size() == 1:
			pick_up(items[0])


func _process(_delta):
	if is_open:
		pass
		$CanvasLayer/Shelf/Select.global_position = inv.inventory["Fridge"][space_select]["Spot"].global_position
		if Input.is_action_just_pressed("move_right"):
				if space_select < 11:
					space_select += 1
		if Input.is_action_just_pressed("move_left"):
				if space_select > 0:
					space_select -= 1
		if Input.is_action_just_pressed("move_down"):
				if space_select + 4 < 12:
					space_select += 4
		if Input.is_action_just_pressed("move_up"):
				if space_select - 4 >= 0:
					space_select -= 4
					
		if not just_opened:
			if Input.is_action_just_pressed("pick_up"):
				var user = get_tree().get_nodes_in_group("Player")
				use(user[0])
			if Input.is_action_just_pressed("use"):
				var user = get_tree().get_nodes_in_group("Player")
				ui_interact(user[0])
		just_opened = false


func ui_interact(player):
	if not $CanvasLayer/Shelf.visible:
		$CanvasLayer/Shelf.visible = true
		player.disable_input += ["Move", "Pick Up", "Interact"]
		is_open = true
		just_opened = true
	else:
		$CanvasLayer/Shelf.visible = false
		player.disable_input.erase("Move")
		player.disable_input.erase("Pick Up")
		player.disable_input.erase("Interact")
		is_open = false


func use(player):
	var selected_space = item_space(space_select)
	if is_open and selected_space.Item and not player.held_item:
		if infinite:
			player.pick_up(copy(selected_space.Item))
		else:
			player.pick_up(remove_item(selected_space))
		ui_interact(player)
	elif player.held_item:
		if add(player, "Fridge", "add"):
			pass


func remove_food(item_spot, location):
	var item = item_spot.Item
	remove_item(item_spot, location)
	return item
