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

# Objects
var menu = ["Cake", "Chocolate Cake"]
var door
var table
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
		var bodies = $DetectorPlayer.get_overlapping_bodies()
		for body in bodies:
			if body.name == "Table":
				table = body
				break
		order()
	elif state == "ordered":
		var plate = table.check_item(self)
		if plate["In Use"] and not $EatTimer.time_left:
			if plate["Held Item"].food_name == item_chosen:
				if plate["Held Item"].state == "uncooked":
					talk("That's not cooked!")
				else:
					plate["Held Item"].player = self
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
	item_chosen = menu[rand_range(0, menu.size())]
	print(item_chosen)
	state = "ordered"


func eat():
	pick_up(table.remove_item(table.plates[table.nearest_plate(self)]["Held Item"]))
	$AnimationPlayer.play("eat")
	held_item.get_node("AnimationPlayer").play("eat")
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
	if not table.plates[table.nearest_plate(self)]:
		pass
	else:
		eat()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "eat":
		state = "ate"
		closet_chair.in_use = false
	pass # Replace with function body.
