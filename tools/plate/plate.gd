extends ToolBase

func _ready():
	selector = $Select
	collision = $CollisionShape2D
	ui_location = self
	tool_object = $PlateObject
	set_item(self)
	var food_spots = $PlateObject/FoodSpots.get_children()
	set_up("Plate", food_spots.size(), {"Spot": food_spots})
	item_name = "Plate"
	item_type = "tool"
	valid_spaces += ["Table"]
	
	
func _process(_delta):
	pass


func use(player):
#	var held_item = player.held_item
#	var pan_foods = get_spaces()
	if ObjectUI.is_open:
		var food_space = item_space(ObjectUI.space_select)
		if food_space["Item"]:
			remove_item(food_space, "Plate", player.hand)	
	elif add(player, "Plate", "add"):
		return


func get_input():
	pass
#	if Input.is_action_just_pressed("move_right"):
#			if space_select < 2:
#				space_select += 1
#			elif space_select == inv_size() - 1:
#				space_select = 0
#	if Input.is_action_just_pressed("move_left"):
#			if space_select > 0:
#				space_select -= 1
#			elif space_select == 0:
#				space_select = (inv_size()) - 1
##	if Input.is_action_just_pressed("move_down"):
##			if space_select + 2 < 3:
##				space_select += 2
##	if Input.is_action_just_pressed("move_up"):
##			if space_select - 2 >= 0:
##				space_select -= 2
#	if Input.is_action_just_pressed("pick_up"):
#		var player = get_tree().get_nodes_in_group("Player")
#		use(player[0])
