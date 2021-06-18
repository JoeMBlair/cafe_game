tool
extends ApplianceBase

export var infinite = false setget change_infinite
export var fridge_colour : Color = Color.cornflower setget colour_set
export(String, "closed", "open") var state setget fridge_state


var is_open = false
var space_select = 0
var just_opened = false
var prev_colour : Color = fridge_colour
var fridge_hue = 0
var fridge_location
var fridge_node
#var inv_selection = "Fridge"


#Components
onready var inside_light = get_node("Light")
onready var shelf_spaces = get_node("ShelfSpaces")
onready var door_shelf_spaces = get_node("Door/DoorShelfSpaces")
onready var fridge_sprite = get_node("AnimatedSprite")

func change_infinite(test):
	print(test)

func _ready():
	if not Engine.editor_hint:
		fridge_state("closed")
		selector = get_node("Select")
		anim_player = get_node("AnimationPlayer")
		collision = get_node("Collison/CollisionShape2D")
		ui_scale = Vector2(4, 4)
		var shelf_spots = shelf_spaces.get_children()
		var door_shelf_spots = door_shelf_spaces.get_children()
		var inventory_size = shelf_spots.size() + door_shelf_spots.size()
		set_up("Fridge", shelf_spots.size(), {"Spot": shelf_spots})
		set_up("Fridge Door", door_shelf_spots.size(), {"Spot": door_shelf_spots})
		
		for space in get_spaces("Fridge", null, null, "all"):
			var items = space.Spot.get_children()
			if items.size() == 1:
				pick_up(items[0], "Fridge", null, space["Space Index"])
		for space in get_spaces("Fridge Door", null, null, "all"):
			var items = space.Spot.get_children()
			if items.size() == 1:
				pick_up(items[0], "Fridge Door", null, space["Space Index"])


func fridge_state(state_val):
	if is_inside_tree():
		$AnimationPlayer.play(state_val)
		state = state_val

func _physics_process(delta):
	pass

func colour_set(colour):
	if is_inside_tree():
		fridge_colour = colour
		$FridgeColour.modulate = colour
		$Door/DoorColour.modulate = colour

func _process(_delta):
	if not Engine.editor_hint:
		pass
#		if is_open:
#			pass
#			if selector.global_position.distance_to(inv.inventory[inv_selection][space_select]["Spot"].global_position) > 0.1:
#				selector.global_position = inv.inventory[inv_selection][space_select]["Spot"].global_position
#
#			if Input.is_action_just_pressed("move_right"):
#				if space_select < inv_size() - 1:a
#					space_select += 1
#				elif space_select == inv_size() - 1:
#					space_select = 0
#			if Input.is_action_just_pressed("move_left"):
#				if space_select > 0:
#					space_select -= 1
#				elif space_select == 0:
#					space_select = inv_size() - 1
#			if Input.is_action_just_pressed("move_down"):
#				if space_select + 4 < 12:
#					space_select += 4
#			if Input.is_action_just_pressed("move_up"):
#				if space_select - 4 >= 0:
#					space_select -= 4
#
#			if not just_opened:
#				if Input.is_action_just_pressed("pick_up"):
#					var user = get_tree().get_nodes_in_group("Player")
#					use(user[0])
#				if Input.is_action_just_pressed("use"):
#					var user = get_tree().get_nodes_in_group("Player")
#					ui_interact(user[0])
#				if Input.is_action_just_pressed("switch"):
#					match inv_selection:
#						"Fridge": inv_selection = "Fridge Door"
#						"Fridge Door": inv_selection = "Fridge"
#					space_select = 0
#			just_opened = false

func pick_up(item = null, location = inv.default_location, hand = null, space_index = -1):	
		var result = .pick_up(item, location, hand, space_index)
		if result:
			var shadow = load("res://furniture/fridge/shadow.tscn").instance()
			
			result.Spot.add_child(shadow)
			result.Spot.move_child(shadow, 0)


func remove_item(space, location = inv.default_location, hand = null):
	var result = .remove_item(space, location, hand)
	if result:
#		space.Spot.get_node("Shadow").queue_free()
		return result


func use(player):
	var selected_space = item_space(ObjectUI.space_select, ObjectUI.location_names[ObjectUI.inv_selection])
	if ObjectUI.is_open and selected_space.Item and not player.held_item:
		if infinite:
			player.pick_up(copy(selected_space.Item))
		else:
			player.pick_up(remove_item(selected_space, ObjectUI.location_names[ObjectUI.inv_selection]))
		ui_interact(player)
	elif player.held_item:
		if add(player, "Fridge", "add"):
			pass


func remove_food(item_spot, location):
	var item = item_spot.Item
	remove_item(item_spot, location)
	return item
