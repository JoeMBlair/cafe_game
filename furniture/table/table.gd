extends StaticBody2D

var type = "Interactable"
var held_item = null
var held_items = [null, null, null, null]
var food_spots = []
var chosen_spot
var spots = {}


func _ready():
	
	food_spots = get_tree().get_nodes_in_group("FoodSpot")
	for spot in food_spots:
		spots[spot] = {"node": spot, "In Use": false}
	print(spots.values())
	print(spots.keys())

func _process(delta):
	if Input.is_action_just_pressed("Debug"):
		print("Table - Held item: %s" % held_item)

func use(player):
	chosen_spot = nearest_food_spot(player)	
	if player.held_item != null:
		if not spots[chosen_spot]["In Use"]:
			if player.held_item.is_in_group("Food"):
				held_item = player.remove_item()
				pick_up(held_item)
	elif held_item and player.held_item == null:
		spots[chosen_spot]["In Use"] = false		
		player.pick_up(remove_item())

func pick_up(item):
	item.held = true
	item.player = self
	item.hand = chosen_spot
	held_item = item
	spots[chosen_spot]["In Use"] = true
	

func remove_item():
	var item = held_item
	item.held = false
	item.hand = null
	held_item = null
	spots[chosen_spot]["In Use"] = false
	return item

func nearest_food_spot(player):
	var nearest_spot = food_spots[0]
	for spot in food_spots:
		var distance_to_spot = player.global_position.distance_to(spot.global_position)
		var distance_to_nearest_spot = player.global_position.distance_to(nearest_spot.global_position)
		if distance_to_spot < distance_to_nearest_spot:
			nearest_spot = spot
	return nearest_spot
