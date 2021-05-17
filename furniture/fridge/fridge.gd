extends StaticBody2D

var type = "Interactable"
var inventory = []
var shelf_spaces = []
var open = false
var space_select = 0

func _ready():
	$CanvasLayer/Shelf.visible = false
	var shelf_spots = $CanvasLayer/Shelf/ShelfSpaces.get_children()
	for spot in shelf_spots:
		shelf_spaces.append({"Shelf Node": spot, "Item Node": null})


func _process(delta):
	if open:
		pass
		$CanvasLayer/Shelf/Select.global_position = shelf_spaces[space_select]["Shelf Node"].global_position
		if Input.is_action_just_pressed("move_right"):
				if space_select < 11:
					space_select += 1
		if Input.is_action_just_pressed("move_left"):
				if space_select > 0:
					space_select -= 1
		if Input.is_action_just_pressed("move_down"):
				if space_select + 4 < 11:
					space_select += 4
		if Input.is_action_just_pressed("move_up"):
				if space_select - 4 >= 0:
					space_select -= 4
		

func use(player):
	if player.held_item:
		pick_up(player.remove_item())
	elif shelf_spaces[space_select]["Item Node"] and open:
		pass
		var selected_item = shelf_spaces[space_select]["Item Node"]
		player.pick_up(remove_item(selected_item, player))
	else:
		open(player)
	


func pick_up(item):
	item.held = true
#	inventory.append(item)
	for space in shelf_spaces.size():
		var shelf_spot = shelf_spaces[space]
		if  not shelf_spot["Item Node"]:
			item.hand = shelf_spot["Shelf Node"]
			item.get_parent().remove_child(item)
			shelf_spot["Shelf Node"].add_child(item)
			shelf_spot["Item Node"] = item
			item.scale = Vector2(2,2)
			break


func remove_item(item, character):
	item.hand = null
	item.get_parent().remove_child(item)
	get_node("/node/Main").add_child(item)
	shelf_spaces["Item Node"] = null
	pass


func open(character):
	if not $CanvasLayer/Shelf.visible:
		$CanvasLayer/Shelf.visible = true
		character.move = false
		open = true
	else:
		$CanvasLayer/Shelf.visible = false
		character.move = true
		open = false
