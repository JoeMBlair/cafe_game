extends ApplianceBase

var food_spots = []
var chosen_plate


func _ready():
	food_spots = $FoodSpots.get_children()
	var in_use = []
	for spot in food_spots:
		in_use.append(false)
	var params = {"Spot": food_spots, "In Use": in_use}
	set_up("Table", 4, params)


func _process(_delta):
	if Input.is_action_just_pressed("Debug"):
		pass

func use(player):
	chosen_plate = nearest_plate(player)
	
	if not chosen_plate["In Use"]:
		if player.held_item and not chosen_plate.Item:
			if player.held_item.is_in_group("Food"):
				pick_up(player.remove_item(player.held_space), player.location_name(), null, chosen_plate["space Index"])
		elif not player.held_item and chosen_plate.Item:
			player.pick_up(remove_item(chosen_plate))


func check_item(player):
	return nearest_plate(player)


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
