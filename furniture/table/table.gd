extends ApplianceBase

var food_spots = []
var chosen_plate


func _ready():
#	object = self
	food_spots = $FoodSpots.get_children()
	var in_use = []
	for spot in food_spots:
		in_use.append(false)
	var params = {"Spot": food_spots, "In Use": in_use}
	set_up("Default", 4, params)
	

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("Debug"):
		pass

func use(player):
	chosen_plate = nearest_plate(player)
	
	if not chosen_plate["In Use"]:
		if player.held_item and not chosen_plate.Item:
			if player.held_item.is_in_group("Food"):
				
				pick_up(player.remove_item(player.held_slot), "Default", null, chosen_plate["Slot Index"])
		elif not player.held_item and chosen_plate.Item:
			player.pick_up(remove_item(chosen_plate))


#func add(player, location, action, hand = null):
#	if not player.held_item:
#		return false
#	var held_item = player.held_item
#	if held_item.valid_item(held_item, location, action):
#		var player_food = player.remove_item(player.held_slot)
#		pick_up(player_food)
#		return true
#	return false


func check_item(player):
	return nearest_plate(player)


func nearest_plate(player):
	food_spots = get_slots("Default", null, null, "all")
	var nearest_plate = food_spots[0]
	for spot in food_spots:
		var plate_spot = spot["Spot"]
		var distance_to_spot = player.global_position.distance_to(plate_spot.global_position)
		var distance_to_nearest_spot = player.global_position.distance_to(nearest_plate["Spot"].global_position)
		if distance_to_spot < distance_to_nearest_spot:
			nearest_plate = spot
	return nearest_plate
