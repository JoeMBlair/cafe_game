extends StaticBody2D

var type = "Interactable"
var inventory = []

func use(player):
	if player.held_item:
		pick_up(player.remove_item())


func pick_up(item):
	item.held = true
	inventory.append(item)
	item.hand = get_node(".")


func remove_item():
	pass
