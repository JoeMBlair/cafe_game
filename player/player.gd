extends KinematicBody2D

# Movement
export var speed = 200
var velocity = Vector2.ZERO
var direction = Vector2.ZERO 
var direction_name : String setget set_direction
var prev_direction
var state = "idle" setget set_state
var anim_name = "idle_down"
var inputs_held : Array
var input_convert = {"x": [1, -1], "y": [1,-1]}

# Body
onready var body_sprite = get_node("AnimatedSprite")
onready var hand = get_node("Hand")
onready var detector_radius = get_node("DetectorRadius")

# Inventory
var inv = preload("res://inventory.tscn").instance()
var inv_location = "Player"
var held_space
var held_item
var pick_ups = []
var interactables = []

# Controls
var disable_input = []
onready var anim_player = get_node("AnimationPlayer")
onready var anim_player_rotate = get_node("AnimationPlayerRotation")
var set_idle = false

# Debug
var glo_pos
var glo_pos_item


func _ready():
	self.add_child(inv)
	inv.set_up(inv_location, 1)

func valid_actions(type):
	var valid_pickups = []
	var valid_interacts = []
	
	match type:
		"PickUp":
			for pick_up in pick_ups:
				if  held_item == pick_up:
					continue
				elif not pick_up.detect:
					continue
				else:
					valid_pickups += [pick_up]
			return valid_pickups
		"Interact":
			for interact in interactables:
				if not held_item == interact and not interact.held:
					valid_interacts += [interact]
			return valid_interacts

func _process(_delta):
	debug()
#	glo_pos = $Hand.global_position
#	if velocity != Vector2.ZERO:
#	get_actions()
	if held_item:
		glo_pos_item = held_item.global_position
			
	if state != "idle" and velocity == Vector2.ZERO:
		set_state("idle")
		
#func change_z_index():
#		if held_item and held_item.item_type == "tool":
#			if not held_item.is_open:
#
#				anim_player.play(String("held_" + state + "_" + direction))
#				if held_item.item_name == "Frying Pan":
#					held_item.anim_player.play(direction)
#					pass
#				if direction == "up":
#					held_item.modulate = Color(1, 1, 1, 0.5)
#				else:
#					held_item.modulate = Color(1, 1, 1, 1)
#		else:
#			anim_player.play(String(state + "_" + direction))


func _physics_process(delta):
	if disable_input.has("Move") and  anim_player.current_animation:
		anim_player.stop()
	elif not disable_input and not anim_player.current_animation and anim_player.assigned_animation:
		anim_player.play()
		
	get_input()
#	direction.x *= speed
#	direction.y *= speed
	
	if not direction.x == 0:
		if velocity.x > 0 and direction.x < 0:
			velocity.x = 0
		if velocity.x < 0 and direction.x > 0:
			velocity.x = 0
		velocity.x = lerp(velocity.x, direction.x * speed, 0.05)
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
		if abs(velocity.x) < 8:
			velocity.x = 0
		
	if not direction.y == 0:
		if velocity.y > 0 and direction.y < 0:
			velocity.y = 0
		if velocity.y < 0 and direction.y > 0:
			velocity.y = 0
		velocity.y = lerp(velocity.y, direction.y * speed, 0.1)
	elif direction.y == 0:
		velocity.y = lerp(velocity.y, 0, 0.2)
		if abs(velocity.y) < 8:
			velocity.y = 0
		
	velocity = move_and_slide(velocity)
	if velocity == Vector2.ZERO and state != "idle":
		set_state("idle")
	elif velocity > Vector2.ZERO and state != "walk":
		set_state("walk")
		
	#Movement
	if not velocity == Vector2.ZERO and not state == "walk":
		state = "walk"
	elif velocity == Vector2.ZERO and not state == "idle":
		set_state("idle")
		
	if "walk" in String(anim_player.current_animation) and velocity == Vector2.ZERO:
		set_state("idle")
	
	if not held_item:
		$Hand/HandSprite.visible = false


func set_direction(player_direction):
	direction_name = player_direction
	held_item = inv.get_spaces("Player", "Item")
	if held_item.size() == 0:
		held_item = null
	else:
		held_item = held_item[0]
	anim_name = "walk_" + direction_name
	if held_item:
		anim_name = "held_" + anim_name
		if direction_name == "up":
			held_item.modulate = Color(1, 1, 1, 0.5)
		else:
			held_item.modulate = Color(1, 1, 1, 1)
		if held_item.item_name == "Frying Pan":
			held_item.anim_player.play(direction_name)
	anim_player.play(anim_name)
	anim_player_rotate.play(String("direction_" + direction_name))

func set_state(player_state):
	state = player_state
	anim_name = player_state + "_" + direction_name
	if held_item:
		anim_name = "held_" + anim_name
	anim_player.play(anim_name)

func get_input():
#	velocity = Vector2.ZERO
#	direction = Vector2.ZERO
	if velocity == Vector2.ZERO:
		direction = Vector2.ZERO
		inputs_held.clear()
		
	if not disable_input.has("Move"):
		if Input.is_action_just_pressed("move_right"):
#			direction.x = 1
			inputs_held += ["right"]
#			set_direction("right")
		if Input.is_action_just_released("move_right"):
#			direction.x = 0
			inputs_held.erase("right")
			
		if Input.is_action_just_pressed("move_left"):
#			direction.x = -1
			inputs_held += ["left"]
#			set_direction("left")
		if Input.is_action_just_released("move_left"):
#			direction.x = 0
			inputs_held.erase("left")
			
		if Input.is_action_just_pressed("move_down"):
#			direction.y = 1
			inputs_held += ["down"]
#			set_direction("down")
		if Input.is_action_just_released("move_down"):
			direction.y = 0
			inputs_held.erase("down")
			
		if Input.is_action_just_pressed("move_up"):
#			direction.y = -1
			inputs_held += ["up"]
#			set_direction("up")
		if Input.is_action_just_released("move_up"):
#			direction.y = 0
			inputs_held.erase("up")
#		print(inputs_held)
		
		if inputs_held.size() == 0:
			direction = Vector2.ZERO
		else:
			var direction_x
			var direction_y
			var anim_direction
			for input in inputs_held:
				if input == "left" or input == "right":
					direction_x = input
				if input == "up" or input == "down":
					direction_y = input
				if inputs_held[0] == "up" or inputs_held[0] == "down":
						anim_direction = input
				if inputs_held[0] == "left" or inputs_held[0] == "right":
						anim_direction = input
			
			set_direction(anim_direction)
			
			if direction_x == "left":
				direction.x = -1
			elif direction_x == "right":
				direction.x = 1
			if direction_y == "up":
				direction.y = -1
			elif direction_y == "down":
				direction.y = 1
		

	if not disable_input.has("Pick Up"):
		if Input.is_action_just_pressed("pick_up"):
			action()
			
	if not disable_input.has("Use"):
		if Input.is_action_just_pressed("use"):
			if held_item and held_item.has_ui:
				held_item.ui_interact(self)
			else:
				var nearest_interactable = nearest_action(valid_actions("Interact"))			
				if nearest_interactable:
					nearest_interactable.ui_interact(self)
	if not disable_input.has("Drop"):
		if Input.is_action_just_pressed("Drop"):
				if held_item != null:
					remove_item(held_space)
		
		if Input.is_action_just_pressed("eat") and held_item != null:
			if held_item.is_cooked:
				eat()
#		return false		
	else:
		anim_player.stop()
#	if velocity.y > 0 and direction != "down":
#	elif velocity.y < 0 and direction != "up":
#	elif velocity.x > 0 and direction != "right":
#	elif velocity.x < 0 and direction != "left":
		
	direction = direction.normalized()


func action():
#	Interact with objects of pick up
	var nearest_pick_up = nearest_action(valid_actions("PickUp"))
	var nearest_interactable = nearest_action(valid_actions("Interact"))
	if nearest_pick_up and not held_item:
		pick_up(nearest_pick_up)
#		change_z_index()
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


func nearest_action(actions, type = "default"):
	if actions != []:
		
		var nearest_action = actions[0]
		if nearest_action == held_item and type == "Interact":
			actions.erase(nearest_action)
			
		for action in actions:
			
			if action < nearest_action:
				nearest_action = action
		return nearest_action
	return false


func remove_item(space):
	var held_object = inv.remove_item(space)
	
	held_item.modulate = Color(1, 1, 1, 1)
	held_item = null
	held_space = null
	return held_object


func pick_up(item, location = inv_location, player_hand = hand, space_index = -1):
	if inv.pick_up(item, location, player_hand, space_index):
#		yield(get_tree().create_timer(0.5), "timeout")
		set_direction(direction_name)
#		pick_ups.erase(item)
#		interactables.erase(item)
		
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
#		area.modulate = Color( 1, 0, 0, 1)

	if area.is_in_group("PickUp"):
		if area.get_owner() == self.get_owner() or area.get_owner() == null:
			pick_ups.append(area)
#		else:
#			pick_ups.append(area.get_parent())
#		area.modulate = Color( 0, 0, 1, 1)
	
	if area.is_in_group("PickUp") and  area.is_in_group("Interactable"):
		pass
#		area.modulate = Color( 0.63, 0.13, 0.94, 1) 
		

func _on_DetectorRadius_area_exited(area):
	if area.is_in_group("Interactable"):
		interactables.erase(area)
		area.modulate = Color.white
		
	if area.is_in_group("PickUp"):
		if area.get_owner() == self.get_owner()or area.get_owner() == null:
			pick_ups.erase(area)
#		else:
#			pick_ups.erase(area.get_parent())
		area.modulate = Color.white
	
		
		
