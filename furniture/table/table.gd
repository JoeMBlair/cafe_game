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
	print(plates.values())
	print(plates.keys())
	

func _process(delta):
	if Input.is_action_just_pressed("Debug"):
		print("Table - Held item: %s" % held_item)

func use(player):
	chosen_plate = nearest_plate(player)	
	if player.held_item != null:
		if not plates[chosen_plate]["In Use"]:
			if player.held_item.is_in_group("Food"):
				held_item = player.remove_item()
				pick_up(held_item)
	elif held_item and player.held_item == null:
		plates[chosen_plate]["In Use"] = false
		player.pick_up(remove_item())

func pick_up(item):
	item.held = true
	item.player = self
	item.hand = chosen_plate
	plates[chosen_plate]["Held Item"] = item
	plates[chosen_plate]["In Use"] = true
	

func remove_item():
	var item = held_item
	item.held = false
	item.hand = null
	plates[chosen_plate]["Held Item"] = null	
	plates[chosen_plate]["In Use"] = false
	return item

func nearest_plate(player):
	var nearest_plate = food_spots[0]
	for spot in food_spots:
		var distance_to_spot = player.global_position.distance_to(spot.global_position)
		var distance_to_nearest_spot = player.global_position.distance_to(nearest_plate.global_position)
		if distance_to_spot < distance_to_nearest_spot:
			nearest_plate = spot
	return nearest_plate
