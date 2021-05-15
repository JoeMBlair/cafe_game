extends KinematicBody2D

var state = "idle"
var chairs
var seated = false
var chosen_chair
var vector2vector = Vector2.ZERO
var closet_chair
var direction
var velocity = Vector2.ZERO
var speed = 100
var ordered = false
var menu = ["Cake", "Chocolate Cake"]
var item_chosen
var player_in_range = false
var table
var held_item
var eaten = false
var door
var at_home = false

func debug():
	if Input.is_action_just_pressed("Debug"):
		pass


func _ready():
	chairs = get_tree().get_nodes_in_group("Chair")
	choose_chair()
	state = "goto_chair"


func _process(delta):
	if state == "goto_chair":
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
		if table.held_item != null and not $EatTimer.time_left:
			if table.held_item.food_name == item_chosen:
				talk("Thank you!")
				$EatTimer.start()
				print($EatTimer.paused)
			else:
				talk("That's not what I ordered.")
				$SpeechBubble.visible = true
				$Speech.text = "That's not what I ordered."
	elif state == "ate":
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
	for chair in chairs:
		if not chair.in_use:
			if chair.global_position.distance_to(self.global_position) < closet_chair.global_position.distance_to(self.global_position):
				closet_chair = chair
	chosen_chair = closet_chair
	closet_chair.in_use = self

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
	if not seated:
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
	pick_up(table.remove_item())
	$AnimationPlayer.play("eat")
	held_item.get_node("AnimationPlayer").play("eat")
	state = "eaten"

func pick_up(item):
	if not item:
		return
	held_item = item
	item.held = true
	item.hand = get_node("DetectorChair")
	item.player = self
	
func remove_item():
	pass

func go_home():
	if not door:
		seated = false
		door = get_tree().get_nodes_in_group("Door")
	if not goto_location(door[0]):
		return false
	else:
		return true
	
	
	


#func _on_DetectorChair_area_entered(area):
#	if area.is_in_group("SitPoint"):
#		state = "seated"
#		self.global_position = area.global_position


func _on_DetectorPlayer_body_entered(body):
	if body.is_in_group("Player"):
		if state == "ordered":
			talk(String("I want %s" % item_chosen))
		player_in_range = true


func _on_DetectorPlayer_body_exited(body):
	if body.is_in_group("Player"):
		$SpeechBubble.visible = false
		$Speech.visible = false
		player_in_range = false


func _on_EatTimer_timeout():
	if not table.held_item:
		eaten = false
	else:
		eat()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "eat":
		state = "ate"
		closet_chair.in_use = false
	pass # Replace with function body.
