extends StaticBody2D

var held_item
var in_zone = false
var player
var type = "Interactable"
var in_use = false

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	pass



func use():
	print("cook")
	if player.held_item != null:
		if not held_item:
			if player.held_item.is_in_group("Food"):
				in_use = true
				held_item = player.held_item
				held_item.hand = get_node("OvenTray")
				player.held_item = null
				held_item.modulate = Color(0,0,0,0)
				held_item.global_position = Vector2.ZERO
				$AnimatedSprite.modulate = Color(1, 0, 0)
				$Timer.wait_time = held_item.cook_time
				$Timer.start()
	elif held_item and player.held_item == null:
		player.held_item = held_item
		held_item.hand = player.get_node("Hand")
		held_item = null


func _on_Detector_body_entered(body):
	if body.is_in_group("Player") and not in_use:
		print("In cooker Zone")
		in_zone = true
		player = body
		player.actions.append(self)


func _on_Detector_body_exited(body):
	if body.is_in_group("Player"):
		print("Out cooker Zone")
		in_zone = false
		
		if player:
			player.actions.erase(self)


func _on_Timer_timeout():
	held_item.modulate = Color(1, 1, 1, 1)
	held_item.get_node("AnimatedSprite").animation = "cooked"
	held_item.global_position = $OvenTray.global_position
	$AnimatedSprite.modulate = Color(1, 1, 1)
	held_item.state = "cooked"
	in_use = false
	pass # Replace with function body.

