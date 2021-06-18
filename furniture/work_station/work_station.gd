extends ApplianceBase

var bowl_inventory 
var board_inventory
var is_open = false
var space_select = 0
#var locations = {"board": get_node("DetectorBoard"), "bowl": get_node("DetectorBowl")}

func _ready():
	$CanvasLayer/Bowl.visible = false
	var bowl_spaces = $CanvasLayer/Bowl/FoodSpaces.get_children()	
	set_up("Cutting Board", 1)
	set_up("Mixing Bowl", 4, {"Spot": bowl_spaces})


func _process(_delta):
	if is_open:
		$CanvasLayer/Bowl/Select.global_position = inv.inventory["Mixing Bowl"][space_select]["Spot"].global_position
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


func use(player):
	if nearest_location(player) == "board":
		use_board(player)
	else:
		use_bowl(player)
		
func nearest_location(player):
	var player_to_bowl = player.global_position.distance_to($DetectorBowl.global_position)
	var player_to_board = player.global_position.distance_to($DetectorBoard.global_position)

	if player_to_board < player_to_bowl:
		return "board"
	else:
		return "bowl"
	
func use_board(player):
	var player_item = player.held_item	
	var board_item = get_spaces("Cutting Board", "Item")
	if player_item and add(player, "Cutting Board", "cut", $CuttingBoard):
		board_item = get_spaces("Cutting Board", "Item")
		return
		#	Checks if you can cut the ingredient if true then it cuts it up
	elif not player.held_item and board_item.size() != 0:
		if not board_item[0].is_cut:
			board_item[0].cut()
		else:
			var board_space = get_spaces("Cutting Board")
			board_space = board_space[0]
			player.pick_up(remove_item(board_space, "Cutting Board"), player.location_name(), player.hand)


func use_bowl(player):
#	Loads ingredient in the bowl
	var occupied_spaces = get_spaces("Mixing Bowl")
	var bowl_foods = get_spaces("Mixing Bowl", "Item")
	var selected_space = inv.inventory["Mixing Bowl"][space_select]
	var player_item = player.held_item
	
	if is_open:
		if selected_space.Item and not player.held_item:
			player.pick_up(remove_item(selected_space, "Mixing Bowl"), player.location_name(), player.hand)
			ui_interact(player)
	elif add(player, "Mixing Bowl", "add", null):
		bowl_foods = get_spaces("Mixing Bowl", "Item")
		pass
		if bowl_foods.size() == 4:
			mix(null, "Mixing Bowl")
			bowl_foods = get_spaces("Mixing Bowl", "Item")
			occupied_spaces = get_spaces("Mixing Bowl")
		
	elif not player.held_item and bowl_foods:
		player_item = remove_item(occupied_spaces[bowl_foods.size()-1], "Mixing Bowl")
		player_item.visible = true
		player.pick_up(player_item, player.location_name(), player.hand)


func remove_food(item_spot, location):
	var item = item_spot.Item
	remove_item(item_spot, location)
	return item


func ui_interact(player):
	
	var chosen_location = nearest_location(player)

	if chosen_location == "board":
		ObjectUI.ui_interact(player, self, ui_scale, ui_offset, selector, anim_player, collision)
		ObjectUI.inv_selection = 0:
	else:
		
