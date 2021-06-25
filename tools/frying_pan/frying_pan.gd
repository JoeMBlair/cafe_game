extends ToolBase


func _ready():
	anim_player = get_node("AnimationPlayer")
	anim_player.play("right")
	selector = $FryingPanObject/Select
	tool_object = $FryingPanObject
	ui_location = $PointUI
	ui_offset = Vector2(10, 0)
	var food_spots = $FryingPanObject/FoodSpots.get_children()
	set_up("Frying Pan", 4, {"Spot": food_spots})
	item_name = "Frying Pan"
	item_type = "tool"
	valid_spaces += ["Hob"]
	ui_offset = Vector2(10, -2)


func _process(_delta):
	if held:
		var player = get_tree().get_nodes_in_group("Player")
		player = player[0]


func use(player):
	if ObjectUI.is_open:
		var food_space = item_space(ObjectUI.space_select)
		if food_space["Item"]:
			remove_item(food_space, "Frying Pan", player.hand)			
	elif add(player, "Frying Pan", "add"):
		return


func ui_interact(player):
	.ui_interact(player)


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
	if Input.is_action_just_pressed("move_down"):
			if space_select + 2 < inv_size():
				space_select += 2
	if Input.is_action_just_pressed("move_up"):
			if space_select - 2 >= 0:
				space_select -= 2
	if Input.is_action_just_pressed("pick_up"):
		var player = get_tree().get_nodes_in_group("Player")
		use(player[0])

