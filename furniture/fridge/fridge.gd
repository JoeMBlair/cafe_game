extends ApplianceBase

var shelf_spaces = []
var is_open = false
var space_select = 0
var infinite = true
var spaces_left : int
#var fridge_inventory
var just_opened = false
var user

func _ready():
	object = self
	var shelf_spots = $CanvasLayer/Shelf/ShelfSpaces.get_children()	
	set_up("Fridge", shelf_spots.size(), {"Spot": shelf_spots})
	
	$CanvasLayer/Shelf.visible = false
#	spaces_left = shelf_spots.size()
#	for spot in shelf_spots:
#		shelf_spaces.append(spot)

	for slot in inventory["Fridge"]:
		var item = inventory["Fridge"][slot]["Spot"]
		var items = item.get_children()
		print(items[0].name)
		if items.size() == 2:
			pick_up(items[1], "Fridge")
			items[1].scale = Vector2(3,3)


func _process(delta):
	if is_open:
		pass
		$CanvasLayer/Shelf/Select.global_position = inventory["Fridge"][space_select]["Spot"].global_position
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
#		if Input.is_action_just_pressed("use") and not just_opened:
#			open_ui(get_node("/root/Main/Objects/Player"))
		just_opened = false
		if Input.is_action_just_pressed("pick_up"):
			pass

func ui_interact(player):
	user = player
	if not $CanvasLayer/Shelf.visible:
		$CanvasLayer/Shelf.visible = true
		player.disable_input += ["Move"]
		is_open = true
		just_opened = true		
	else:
		$CanvasLayer/Shelf.visible = false
		player.disable_input.erase("Move")
		is_open = false


func use(player):
	var selected_slot = inventory["Fridge"][space_select]
	if is_open and selected_slot.Item and not player.held_item:
		player.pick_up(remove_food(inventory["Fridge"][space_select], "Fridge"))
		ui_interact(user)
	elif player.held_item:
		if add(player, "Fridge", "add"):
			pass


func add(player, location, action):
	var item = player.held_item
	if item.valid_item(item, location, action):
		var player_food = player.remove_item()
		pick_up(player_food, location)	
		item.scale = Vector2(3, 3)
		return true
	return false


func copy_item(item):
	pass


func remove_food(item_spot, location):
	var item = item_spot.Item
	remove_item(item_spot, location)
	item.scale = Vector2(1, 1)
	return item
