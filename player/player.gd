extends KinematicBody2D

export var speed = 200
var velocity = Vector2.ZERO
var direction = "down"
var state = "idle"
var in_zone = false
#var item
var held_item
var actions = []
var object
onready var body_sprite = get_node("AnimatedSprite")
onready var anim_player = get_node("AnimationPlayer")


# warning-ignore:unused_argument
func _process(delta):
	debug()
	
	if Input.is_action_just_pressed("interact"):
		action()
	if Input.is_action_just_pressed("Drop"):
		if held_item != null:
			remove_item()


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
	
	
	if Input.is_action_just_pressed("eat") and held_item != null:
		if held_item.state == "cooked":
			eat()


func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
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
	if actions != []:
		var nearest_action = actions[0]
		
		for action in actions:
			if action < nearest_action:
				nearest_action = action
			
		if nearest_action.type == "PickUp" and not held_item and nearest_action.player != self:
			pick_up(nearest_action)	
		elif nearest_action.type == "Interactable":
			nearest_action.use(self)
	


func debug():
	if Input.is_action_just_pressed("Debug"):
		print("Actions:")		
		if not actions == []:
			for action in actions:
				print(action.name)
		else:
			print("none")
		if held_item:
			held_item.state = "cooked"
			held_item.get_node("AnimatedSprite").animation = "cooked"

func eat():
	$AnimationPlayer.play("eat")
	held_item.get_node("AnimationPlayer").play("eat")

func remove_item():
	var item = held_item
	item.held = false
	item.hand = null
	item.player = null
	held_item = null
	return item
	
# warning-ignore:shadowed_variable
func pick_up(item):
	item.held = true
	item.player = self	
	item.hand = get_node("Hand")
	held_item = item
	actions.erase(item)
		
#	Checks for objects to interact with or pick up and adds them to an action 
#	queue or removes them if out of range
func _on_DetectorRadius_area_entered(area):
	if area.is_in_group("Interactable"):
		if area.get_owner() == self.get_owner():
			actions.append(area)
		else:
			actions.append(area.get_parent())
			
	if area.is_in_group("PickUp") and not held_item and not area.held:
		if area.get_owner() == self.get_owner() or area.get_owner() == null:
			actions.append(area)
		else:
			actions.append(area.get_parent())
		


func _on_DetectorRadius_area_exited(area):
	if area.is_in_group("Interactable") or area.is_in_group("PickUp"):
		if area.get_owner() == self.get_owner()or area.get_owner() == null:
			actions.erase(area)
		else:
			actions.erase(area.get_parent())
	
