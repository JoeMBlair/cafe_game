extends StaticBody2D

var type = "Interactable"
var held_item = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func use(player):
	if player.held_item != null:
		if not held_item:
			if player.held_item.is_in_group("Food"):
				held_item = player.remove_item()
				pick_up(held_item)
	elif held_item and player.held_item == null:
		player.pick_up(remove_item())

func pick_up(item):
	held_item = item
	item.held = true
	item.hand = get_node("Detector")
	item.player = self

func remove_item():
	var give_item = held_item
	held_item.held = false
	held_item.hand = null
	held_item = null
	return give_item
