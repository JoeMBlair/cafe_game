extends KinematicBody2D

export var speed = 200
var disable_input = []
var velocity = Vector2.ZERO
var direction = "down"
var state = "idle"
var in_zone = false
#var item
var held_item
#var actions = []
var pick_ups = []
var interactables = []
var object
var glo_pos
var glo_pos_item
onready var body_sprite = get_node("AnimatedSprite")
onready var anim_player = get_node("AnimationPlayer")


# warning-ignore:unused_argument
func _process(delta):
	debug()
	glo_pos = $Hand.global_position
	if held_item:
		glo_pos_item = held_item.global_position


# warning-ignore:unused_argument
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	
	#Movement
	if not velocity == Vector2.ZERO and not state == "walk":
		state = "walk"
	elif velocity == Vector2.ZERO and not state == "idle":
		state = "idle"
	
	anim_player.play(String(state + "_" + direction))


func get_input():
	velocity = Vector2.ZERO
	
	if not disable_input.has("Move"):
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		
	if not disable_input.has("Pick Up"):
		if Input.is_action_just_pressed("pick_up"):
			action()
	if not disable_input.has("Use"):
		if Input.is_action_just_pressed("use"):
			var nearest_interactable = nearest_action(interactables)
			if nearest_interactable:
				nearest_interactable.ui_interact(self)
		if Input.is_action_just_pressed("Drop"):
			if held_item != null:
				remove_item()
		
		if Input.is_action_just_pressed("eat") and held_item != null:
			if held_item.state == "cooked":
				eat()
		
	if velocity.y > 0:
		direction = "down"
	elif velocity.y < 0:
		direction = "up"
	elif velocity.x > 0:
		direction = "right"
	elif velocity.x < 0:
		direction = "left"
		
	velocity = velocity.normalized() * speed


func action():
#		Interact with objects of pick up
	var nearest_pick_up = nearest_action(pick_ups)
	var nearest_interactable = nearest_action(interactables)
	if nearest_pick_up and not held_item and nearest_pick_up.player != self:
		pick_up(nearest_pick_up)
	elif nearest_interactable:
		nearest_interactable.use(self)


func debug():
	if Input.is_action_just_pressed("Debug"):
		if held_item:
			held_item.state = "cooked"
			held_item.get_node("AnimatedSprite").animation = "cooked"

func eat():
	$AnimationPlayer.play("eat")
	held_item.get_node("AnimationPlayer").play("eat")

func nearest_action(actions):
	if actions != []:
		var nearest_action = actions[0]
		
		for action in actions:
			if action < nearest_action:
				nearest_action = action
		return nearest_action
	return false


func remove_item():
	var item = held_item
	item.get_parent().remove_child(item)
	get_node("/root/Main").add_child(item)
	item.global_position = $Hand.global_position
	item.held = false
#	item.hand = null
	item.player = null
	held_item = null
	return item
	
# warning-ignore:shadowed_variable
func pick_up(item):
	item.held = true
	item.player = self
#	item.hand = get_node("Hand")
	held_item = item
	item.get_parent().remove_child(item)
	$Hand.add_child(item)
	item.position = Vector2(0, 0)
	pick_ups.erase(item)
		
#	Checks for objects to interact with or pick up and adds them to an action 
#	queue or removes them if out of range
func _on_DetectorRadius_area_entered(area):
	if area.is_in_group("Interactable"):
#		if area.get_owner() == self.get_owner():
		interactables.append(area)
#		else:
#			interactables.append(area.get_parent())
			
	if area.is_in_group("PickUp") and not held_item and not area.held:
		if area.get_owner() == self.get_owner() or area.get_owner() == null:
			pick_ups.append(area)
		else:
			pick_ups.append(area.get_parent())


func _on_DetectorRadius_area_exited(area):
	if area.is_in_group("Interactable"):
#		if area.get_owner() == self.get_owner()or area.get_owner() == null:
		interactables.erase(area)
#		else:
#			interactables.erase(area.get_parent())
#		print(area.name)
		for object in interactables:
			print(object.name)
		
	if area.is_in_group("PickUp"):
		if area.get_owner() == self.get_owner()or area.get_owner() == null:
			pick_ups.erase(area)
		else:
			pick_ups.erase(area.get_parent())
#		print(area.name)
		
