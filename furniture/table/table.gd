extends StaticBody2D

var type = "Interactable"
var held_item = null
var held_items = [null, null, null, null]
var food_spots = []
var chosen_plate
var plates = {}


func _ready():
	
	food_spots = get_tree().get_nodes_in_group("FoodSpot")
	for spot in food_spots:
		plates[spot] = {"node": spot, "In Use": false, "Held Item": null}
	

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("Debug"):
		pass

func use(player):
	chosen_plate = plates[nearest_plate(player)]
	
	if chosen_plate["In Use"]:
		if chosen_plate["Held Item"].player:
			print(chosen_plate["Held Item"].player.name)
	if player.held_item != null:
		if not chosen_plate["In Use"]:
			if player.held_item.is_in_group("Food"):
				pick_up(player.remove_item())
	elif chosen_plate["In Use"]:
		if player.held_item == null and not chosen_plate["Held Item"].player:
			chosen_plate["In Use"] = false
			player.pick_up(remove_item(chosen_plate["Held Item"]))

func check_item(player):
	return plates[nearest_plate(player)]


func pick_up(item):
	item.held = true
#	item.player = self
	item.hand = chosen_plate["node"]
	chosen_plate["Held Item"] = item
	chosen_plate["In Use"] = true


func remove_item(item):
#	var item = held_item
	item.held = false
	item.hand = null
	item.player = null
	chosen_plate["Held Item"] = null	
	chosen_plate["In Use"] = false
	return item

func nearest_plate(player):
	var nearest_plate = food_spots[0]
	for spot in food_spots:
		var distance_to_spot = player.global_position.distance_to(spot.global_position)
		var distance_to_nearest_spot = player.global_position.distance_to(nearest_plate.global_position)
		if distance_to_spot < distance_to_nearest_spot:
			nearest_plate = spot
	return nearest_plate
