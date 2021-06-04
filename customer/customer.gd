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
var inv = preload("res://inventory.tscn").instance()
var spawn_rate_normal = [1, 1, 1, 1, 1, 1, 1, 2, 2, 3]
var spawn_rate_extreme = [1, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6]
var spawn_rate = spawn_rate_normal



# Objects
var door
var table
var plate
var chairs
var closet_chair
var chosen_chair

func valid_action(user):
	var user_item = user.held_item
	if user_item:
		if user_item.can_cook:
			if user_item.cooked:
				return true
			else:
				return false
		else:
			return true
	else:
		return true


func debug():
	if Input.is_action_just_pressed("Debug"):
		var user = get_tree().get_nodes_in_group("Player")
		if valid_action(user[0]):
			if spawn_rate == spawn_rate_normal:
				spawn_rate = spawn_rate_extreme
				user[0].modulate = Color.red
			else:
				spawn_rate = spawn_rate_normal
				user[0].modulate = Color.white


func _ready():
	self.add_child(inv)
	inv.set_up("Customer", 1)
	chairs = get_tree().get_nodes_in_group("Chair")
	if not choose_chair():
		state = "wait"
	else:
		state = "goto_chair"


func _process(_delta):
	debug()
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
	plate["In Use"] = false
	inv.pick_up(table.remove_item(plate), table.location_name(), $DetectorChair)
	$AnimationPlayer.play("eat")
	var food = inv.get_item_slot(0)
	food.Item.eat()
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
		randomize()
		var amount = spawn_rate[rand_range(0, spawn_rate.size())]
		door = get_tree().get_nodes_in_group("Door")
		
		for i in amount:
			var instance = scene.instance()
			get_node("/root/Main").add_child(instance)
			instance.global_position = door[0].global_position
			instance.global_position.x += rand_range(10, 30)
			instance.global_position.y += rand_range(10, 30)
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
