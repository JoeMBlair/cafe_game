extends KinematicBody2D

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

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	chairs = get_tree().get_nodes_in_group("Chair")
	choose_chair()

func _process(delta):
	if Input.is_action_just_pressed("Debug"):
		pass
	if seated and not ordered:
		var bodies = $DetectorPlayer.get_overlapping_bodies()
		for body in bodies:
			if body.name == "Table":
				table = body
				break
		order()
		print(table.name)
	if not seated:
		if chosen_chair.in_use != self:
			choose_chair()
		goto_seat()
	
	if ordered:
		if table.held_item != null and not eaten:
			if table.held_item.food_name == item_chosen:
				$SpeechBubble.visible = true
				$Speech.text = "Thank you!"
				eaten = true
				$EatTimer.start()
			else:
				$SpeechBubble.visible = true
				$Speech.text = "That's not what I ordered."
	if eaten and not at_home:
		go_home()


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
	ordered = true
	pass

func eat():
#	yield(get_tree().create_timer(3), "timeout")
	pick_up(table.remove_item())
	$AnimationPlayer.play("eat")
	held_item.get_node("AnimationPlayer").play("eat")
	eaten = true

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
	vector2vector = door[0].global_position - self.global_position
	direction = vector2vector.normalized()
	velocity = direction * speed
	velocity = move_and_slide(velocity)
	
	
	


func _on_DetectorChair_area_entered(area):
	if area.is_in_group("SitPoint"):
		seated = true
		self.global_position = area.global_position


func _on_DetectorPlayer_body_entered(body):
	if body.is_in_group("Player"):
		if ordered:
			$SpeechBubble.visible = true
			$Speech.visible = true			
			$Speech.text = "I want %s" % item_chosen
		player_in_range = true
		print("Player in range: %s" % player_in_range)


func _on_DetectorPlayer_body_exited(body):
	if body.is_in_group("Player"):
		$SpeechBubble.visible = false
		$Speech.visible = false
		player_in_range = false
		print("Player in range: %s" % player_in_range)


func _on_EatTimer_timeout():
	if not table.held_item:
		eaten = false
	else:
		eat()
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "eat":
		pass
	pass # Replace with function body.
