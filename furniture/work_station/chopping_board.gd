extends ApplianceBase

var board_inventory
var is_open = false
var space_select = 0
#var locations = {"board": get_node("DetectorBoard"), "bowl": get_node("DetectorBowl")}

func _ready():
	set_up("Cutting Board", 1, {"Spot": [get_node("Board")]})
	selector = $Selector
	ui_scale = Vector2(20, 20)
	ui_offset = Vector2(0, -10)

func use(player):
	use_board(player)


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

func ui_interact(player):
	pass

func remove_food(item_spot, location):
	var item = item_spot.Item
	remove_item(item_spot, location)
	return item
