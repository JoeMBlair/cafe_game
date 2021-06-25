extends KinematicBody2D

# Player
signal state_changed(customer_state)
var state = "idle"
var is_seated = false
var vector2vector = Vector2.ZERO
var direction
var velocity = Vector2.ZERO
var speed = 100
var item_chosen
var player_in_range = false
var held_item
onready var scene = load("res://customer/customer.tscn")
var inv = preload("res://inventory.tscn").instance()
var inv_location = "Customer"
var spawn_rate_normal = [1, 1, 1, 1, 1, 1, 1, 2, 2, 3]
var spawn_rate_extreme = [1, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6]
var spawn_rate = spawn_rate_normal

onready var speech_bubble = get_node("SpeechBubble")
onready var speech_text = get_node("SpeechBubble/SpeechText")

# Objects
var door
var table
var plate
var chairs
var closet_chair
var chosen_chair


func _ready():
	self.add_child(inv)
	inv.set_up(inv_location, 1)
	speech_bubble.visible = false
	print(global_position)	
	

func _process(_delta):
	if state == "home":
		if go_home():
			queue_free()
		
	debug()
	if chosen_chair and not is_seated:
		if goto_location(chosen_chair.Node):
			order()
	elif is_seated:
		if not plate:
			if check_order():
				if plate["Item"]:
					check_plate(plate)
					var plate_food = plate.Item
					if plate_food.item_type == "food":
						if plate_food.can_cook and not plate_food.is_cooked:
							talk("That's not cooked!")
						elif plate_food.can_cook and plate_food.burnt:
							talk("It's burnt!")
						elif plate_food.item_name == item_chosen:
							plate["In Use"] = true
							talk("Thank you!")
							$EatTimer.start()
						else:
							talk("That's not what I ordered.")
#	if state == "ate":
#		talk("Thanks for the meal! Bye.")
#		if go_home():
#			self.queue_free()


func goto_location(object):
	vector2vector = object.global_position - self.global_position
	
	direction = vector2vector.normalized()
	velocity = direction * speed
	velocity = move_and_slide(velocity)
	if abs(vector2vector.y) > 1:
		return false
	else:
		is_seated = true
		return true


func order():
	randomize()
	item_chosen = ItemFood.random_food()
	print(item_chosen)
	state = "ordered"


func check_order():
	var plate_spot = chosen_chair.Plate
	if plate_spot.Item != null:
		plate = plate_spot
		return true
	return false


func check_plate(chosen_plate):
	if chosen_plate.Item.item_type == "tool":
		var plate_food = chosen_plate.Item.item_space(0)
		if plate_food.Item and plate_food.Item.item_type == "food":
				if plate_food.Item.can_cook and not plate_food.Item.is_cooked:
					talk("That's not cooked!")
					return false
				elif plate_food.Item.can_cook and plate_food.Item.burnt:
					talk("It's burnt!")
					return false
				elif plate_food.Item.item_name == item_chosen:
					chosen_plate["In Use"] = true
					talk("Thank you!")
					$EatTimer.start()
				else:
					talk("That's not what I ordered.")


func eat():
	var chosen_food = plate.Item.item_space(0)
	plate["In Use"] = false
	plate.Item.make_dirty()
	inv.pick_up(plate.Item.remove_item(chosen_food), inv_location, $DetectorChair)
	$AnimationPlayer.play("eat")
	var food = inv.item_space(0)
	food.Item.eat()
	state = "eaten"



func go_home():
	if not door:
		randomize()
		door = get_tree().get_nodes_in_group("Door")
#
#		for i in amount:
#			var instance = scene.instance()
#			get_node("/root/Main").add_child(instance)
#			instance.global_position = door[0].global_position
#			instance.global_position.x += rand_range(10, 30)
#			instance.global_position.y += rand_range(10, 30)
	if goto_location(door[0]):
		return true
	else:
		return false


func talk(phrase):
	speech_bubble.visible = true
	speech_text.text = phrase


func debug():
	pass


func _on_DetectorPlayer_body_entered(body):
	if body.is_in_group("Player"):
		if state == "ordered":
			talk(String("%s, please!" % item_chosen))
		player_in_range = true


func _on_DetectorPlayer_body_exited(body):
	if body.is_in_group("Player"):
		speech_bubble.visible = false
		player_in_range = false


func _on_EatTimer_timeout():
		eat()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "eat":
		state = "ate"
		chosen_chair.Node.in_use = false
