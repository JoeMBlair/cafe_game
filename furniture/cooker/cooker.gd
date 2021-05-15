extends StaticBody2D

var held_item
var in_zone = false
var type = "Interactable"
var in_use = false


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func use(player):
	if player.held_item != null:
		if not held_item:
			if player.held_item.is_in_group("Food"):
				held_item = player.remove_item()
				pick_up(held_item)
				in_use = true
				held_item.modulate = Color(0,0,0,0)
				held_item.global_position = Vector2.ZERO
				$AnimatedSprite.modulate = Color(1, 0, 0)
				$Timer.wait_time = held_item.cook_time
				$Timer.start()
	elif held_item and player.held_item == null:	
		player.pick_up(remove_item())


func pick_up(item):
	held_item = item
	item.held = true
	item.hand = get_node("OvenTray")
	item.player = self


func remove_item():
	var item = held_item
	item.held = false
	item.hand = null
	held_item = null
	return item


func _on_Timer_timeout():
	held_item.modulate = Color(1, 1, 1, 1)
	held_item.get_node("AnimatedSprite").animation = "cooked"
	held_item.global_position = $OvenTray.global_position
	$AnimatedSprite.modulate = Color(1, 1, 1)
	held_item.state = "cooked"
	in_use = false
	pass # Replace with function body.

