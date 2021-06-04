extends KinematicBody2D

export var speed = 200
var disable_input = []
var velocity = Vector2.ZERO
var direction = "down"
var state = "idle"
onready var hand = get_node("Hand")
var inv_location = "Player"
var held_item
var held_space
var pick_ups = []
var interactables = []
var glo_pos
var glo_pos_item
onready var body_sprite = get_node("AnimatedSprite")
onready var anim_player = get_node("AnimationPlayer")
var inv = preload("res://inventory.tscn").instance()

func _ready():
	self.add_child(inv)
	inv.set_up(inv_location, 1)


func _process(_delta):
	debug()
	glo_pos = $Hand.global_position
	if held_item:
		glo_pos_item = held_item.global_position


func _physics_process(_delta):
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
				
				remove_item(held_space)
		
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
	if nearest_pick_up and not held_item:
		pick_up(nearest_pick_up)
	elif nearest_interactable:
		nearest_interactable.use(self)


func debug():
	if Input.is_action_just_pressed("Debug"):
		if held_item:
			held_item.cook()
	if Input.is_action_just_pressed("inventory"):
		var fridge = get_tree().get_nodes_in_group("Fridge")
		fridge[0].ui_interact(self)


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


func remove_item(space):
	var held_object = inv.remove_item(space)
	held_item = null
	held_space = null
	return held_object


func pick_up(item, location = inv_location, player_hand = hand, space_index = -1):
	inv.pick_up(item, location, player_hand, space_index)
	for space in inv.get_spaces(location):
		held_space = space
		held_item = space.Item

func location_name():
	return inv.location_name()


#	Checks for objects to interact with or pick up and adds them to an action 
#	queue or removes them if out of range
func _on_DetectorRadius_area_entered(area):
	if area.is_in_group("Interactable"):
		interactables.append(area)
			
	if area.is_in_group("PickUp") and not held_item and not area.held:
		if area.get_owner() == self.get_owner() or area.get_owner() == null:
			pick_ups.append(area)
		else:
			pick_ups.append(area.get_parent())


func _on_DetectorRadius_area_exited(area):
	if area.is_in_group("Interactable"):
		interactables.erase(area)
		
	if area.is_in_group("PickUp"):
		if area.get_owner() == self.get_owner()or area.get_owner() == null:
			pick_ups.erase(area)
		else:
			pick_ups.erase(area.get_parent())
		
