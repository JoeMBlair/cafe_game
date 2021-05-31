extends KinematicBody2D

# Player
var state = "idle"
var vector2vector = Vector2.ZERO
var direction
var velocity = Vector2.ZERO
var speed = 100
var item_chosen
var player_in_range = false
var held_item
onready var scene = load("res://customer/customer.tscn")

# Objects
var door
var table
var plate
var chairs
var closet_chair
var chosen_chair



func debug():
	if Input.is_action_just_pressed("Debug"):
		pass


func _ready():
	chairs = get_tree().get_nodes_in_group("Chair")
	if not choose_chair():
		state = "wait"
	else:
		state = "goto_chair"


func _process(_delta):
	if state == "wait":
		if choose_chair():
			state = "goto_chair"
	elif state == "goto_chair":
		if goto_location(chosen_chair):
			state = "seated"
	elif state == "seated":
		var areas = $DetectorPlayer.get_overlapping_areas()
		for area in areas:
			if area.name == "Table":
				table = area
				break
		plate = table.check_item(self)
		order()
	elif state == "ordered":
		if plate["Item"] and not $EatTimer.time_left:
			if plate["Item"].item_type == "food":
				if plate["Item"].can_cook and not plate["Item"].cooked:
					talk("That's not cooked!")
				elif plate["Item"].can_cook and plate["Item"].burnt:
					talk("It's burnt!")
				elif plate["Item"].item_name == item_chosen:
					plate["Item"].player = self
					plate["In Use"] = true
					talk("Thank you!")
					$EatTimer.start()
				else:
					talk("That's not what I ordered.")
	elif state == "ate":
			talk("Thanks for the meal! Bye.")
			if go_home():
				self.queue_free()


func talk(phrase):
	$SpeechBubble.visible = true
	$Speech.visible = true
	$Speech.text = phrase


func choose_chair():
	if not chosen_chair:
		for chair in chairs:
			if not chair.in_use:
				closet_chair = chair
				break
		if closet_chair == null:
			return false
				
	for chair in chairs:
		if not chair.in_use:
			if chair.global_position.distance_to(self.global_position) < closet_chair.global_position.distance_to(self.global_position):
				closet_chair = chair
	chosen_chair = closet_chair
	closet_chair.in_use = self
	return true


func goto_location(object):
	vector2vector = object.global_position - self.global_position
	direction = vector2vector.normalized()
	velocity = direction * speed
	velocity = move_and_slide(velocity)
	if abs(vector2vector.y) > 1:
		return false
	else:
		return true


func goto_seat():
	if not state == "seated":
		vector2vector = closet_chair.global_position - self.global_position
		direction = vector2vector.normalized()
		velocity = direction * speed
		velocity = move_and_slide(velocity)


func order():
	randomize()
	item_chosen = ItemFood.food_recipes[rand_range(0, ItemFood.food_recipes.size())]["Name"]
	print(item_chosen)
	state = "ordered"


func eat():
	pick_up(table.remove_item(plate, "Table"))
	$AnimationPlayer.play("eat")
	held_item.eat()
	state = "eaten"

func pick_up(item):
	if not item:
		return false
	held_item = item
	item.held = true
	item.hand = get_node("DetectorChair")
	item.player = self


func remove_item():
	var item = held_item
	item.held = false
	item.hand = null
	item.player = null
	held_item = null
	return item


func go_home():
	if not door:
		door = get_tree().get_nodes_in_group("Door")
		
		var instance = scene.instance()
		get_node("/root/Main").add_child(instance)
		instance.global_position = door[0].global_position
	if not goto_location(door[0]):
		return false
	else:
		return true


func _on_DetectorPlayer_body_entered(body):
	if body.is_in_group("Player"):
		if state == "ordered":
			talk(String("I want %s, please!" % item_chosen))
		player_in_range = true


func _on_DetectorPlayer_body_exited(body):
	if body.is_in_group("Player"):
		$SpeechBubble.visible = false
		$Speech.visible = false
		player_in_range = false


func _on_EatTimer_timeout():
		eat()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "eat":
		state = "ate"
		closet_chair.in_use = false
	pass # Replace with function body.
