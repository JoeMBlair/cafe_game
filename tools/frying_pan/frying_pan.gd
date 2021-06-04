extends ToolBase

func _ready():
	var food_spots = $FoodSpots.get_children()
	set_up("Frying Pan", 4, {"Spot": food_spots})
	item_name = "Frying Pan"
	item_type = "tool"
	valid_spaces += ["Hob"]

func _process(delta):
	if is_open:
		var selected_spot = item_space(space_select)
		$Select.global_position = selected_spot.Spot.global_position
		get_input()

func use(player):
	var held_item = player.held_item
	var pan_foods = get_spaces()
	if is_open:
		var food_space = item_space(space_select)
		if food_space["Item"]:
			remove_item(food_space, "Frying Pan", player.hand)			
	elif add(player, "Frying Pan", "add"):
		return

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
	if Input.is_action_just_pressed("pick_up"):
		var player = get_tree().get_nodes_in_group("Player")
		use(player[0])

