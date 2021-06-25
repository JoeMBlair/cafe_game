extends ApplianceBase

var bowl_inventory 
var board_inventory
var is_open = false
var space_select = 0


#func _ready():
#	$CanvasLayer/Bowl.visible = false
#	var bowl_spaces = $CanvasLayer/Bowl/FoodSpaces.get_children()	
#	set_up("Cutting Board", 1)
#	set_up("Mixing Bowl", 4, {"Spot": bowl_spaces})
#
#
#func _process(_delta):
#	if is_open:
#		$CanvasLayer/Bowl/Select.global_position = inv.inventory["Mixing Bowl"][space_select]["Spot"].global_position
#		get_input()
#
#
##func use(player):
##	if nearest_location(player) == "board":
##		use_board(player)
##	else:
##		use_bowl(player)
#
#
#func nearest_location(player):
#	var player_to_bowl = player.global_position.distance_to($DetectorBowl.global_position)
#	var player_to_board = player.global_position.distance_to($DetectorBoard.global_position)
#
#	if player_to_board < player_to_bowl:
#		return "board"
#	else:
#		return "bowl"
#
#
#
#
#func get_input():
#		if Input.is_action_just_pressed("move_right"):
#				if space_select < 3:
#					space_select += 1
#		if Input.is_action_just_pressed("move_left"):
#				if space_select > 0:
#					space_select -= 1
#		if Input.is_action_just_pressed("move_down"):
#				if space_select + 2 < 4:
#					space_select += 2
#		if Input.is_action_just_pressed("move_up"):
#				if space_select - 2 >= 0:
#					space_select -= 2
#
