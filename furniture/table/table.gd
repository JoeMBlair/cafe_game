extends ApplianceBase

var food_spots = []
var chosen_plate
var chairs : Array
onready var detector = get_node("Detector")


func _ready():
	food_spots = $FoodSpots.get_children()
	var in_use = []
	for spot in food_spots:
		in_use.append(false)
	var params = {"Spot": food_spots, "In Use": in_use}
	set_up("Table", 4, params)
	yield(get_tree().create_timer(0.1), "timeout")
#	chairs = get_chairs()


func _process(_delta):
	if Input.is_action_just_pressed("Debug"):
		pass


func ui_interact(player):
	chosen_plate = nearest_plate(player)
	if chosen_plate.Item:
		if chosen_plate.Item.item_type == "tool":
			chosen_plate.Item.ui_interact(player)


func use(player):
	chosen_plate = nearest_plate(player)
	if not chosen_plate["In Use"]:
		var player_item = player.held_item
		if player_item:
			if not chosen_plate.Item:
				if player_item.valid_item("Table", "add"):
					pick_up(player.remove_item(player.held_space), "Table", null, chosen_plate["Space Index"])
			elif chosen_plate.Item.item_name == "Plate":
				if chosen_plate.Item.is_space():
					chosen_plate.Item.pick_up(player.remove_item(player.held_space))
		elif not player_item and chosen_plate.Item:
			player.pick_up(remove_item(chosen_plate))


func check_item(player):
	return nearest_plate(player)


func get_chairs():
	chairs.clear()
	var chair_nodes = $Area2D.get_overlapping_bodies()
	var return_chairs = []
	for single_chair in chair_nodes:
		if single_chair.is_in_group("Chair"):
			var plate = nearest_plate(single_chair)
			return_chairs +=[{"Node": single_chair, "Plate": plate}]
	chairs = return_chairs
	return return_chairs


func nearest_plate(player):
	food_spots = get_spaces("Table", null, null, "all")
	var nearest_plate = food_spots[0]
	for spot in food_spots:
		var plate_spot = spot["Spot"]
		var distance_to_spot = player.global_position.distance_to(plate_spot.global_position)
		var distance_to_nearest_spot = player.global_position.distance_to(nearest_plate["Spot"].global_position)
		if distance_to_spot < distance_to_nearest_spot:
			nearest_plate = spot
	return nearest_plate

