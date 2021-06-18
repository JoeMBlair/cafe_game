extends CanvasLayer

#class_name ObjectUI

var is_open = false
var just_opened = false
var object_node
var ui_scale = 1
var object_location
var selector
var anim_player
var location_node
var collision
var space_select = 0
var location_names : Array
var inv_selection = 0
var player
#var ui_offset = Vector2.ZERO
onready var background = get_node("UI/Background")
onready var layer_ui = get_node("UI")

func _ready():
	background.visible = false
	player = get_tree().get_nodes_in_group("Player")
	player = player[0]

func _process(delta):
	if is_open:
		get_input()


func get_input():
	if Input.is_action_just_pressed("move_right"):
		if space_select < object_node.inv_size() - 1:
			space_select += 1
		elif space_select == object_node.inv_size() - 1:
			space_select = 0
		move_selector()
	if Input.is_action_just_pressed("move_left"):
		if space_select > 0:
			space_select -= 1
		elif space_select == 0:
			space_select = object_node.inv_size() - 1
		move_selector()
	if Input.is_action_just_pressed("move_down"):
		if space_select + 4 < 12:
			space_select += 4
		move_selector()
	if Input.is_action_just_pressed("move_up"):
		if space_select - 4 >= 0:
			space_select -= 4
		move_selector()
		
	if not just_opened:
		pass
		if Input.is_action_just_pressed("pick_up"):
			object_node.use(player)
		if Input.is_action_just_pressed("use"):
			object_node.ui_interact(player)
		if location_names.size() > 1:
			if Input.is_action_just_pressed("switch"):
				match inv_selection:
					0: inv_selection = 1
					1: inv_selection = 0
				space_select = 0
				move_selector()
	just_opened = false

func move_selector():
	var object_space = object_node.item_space(space_select, location_names[inv_selection])
	selector.global_position = object_space.Spot.global_position
	pass

func ui_interact(player, object, ui_scale, ui_offset, object_selector, anim_player, collision):
	if not is_open:
		location_names = object.get_location_names()
		object_node = object
		selector = object_selector
		is_open = true
		just_opened = true
		player.disable_input += ["Move", "Pick Up", "Interact", "Drop"]
		location_node = object.get_parent()
		object_location = object.global_position
		
#		Moves UI to player UI node
		if collision:
			collision.disabled = true
		object.get_parent().remove_child(object)
		layer_ui.add_child(object)
		layer_ui.scale = ui_scale
		object.position = Vector2.ZERO - ui_offset
		
#		Set up graphics for the menu
		if anim_player:
			anim_player.play("open")
			anim_player.play("right")
#			player.set_direction(player.direction)
			player.set_state("idle")
		object_node.modulate = Color.white
		background.visible = true
		layer_ui.scale = ui_scale
		yield(get_tree().create_timer(0.05), "timeout")
		selector.visible = true
		move_selector()
#		move_selector()
		
	else:
		space_select = 0
		inv_selection = 0
		is_open = false
		selector.visible = false		
		player.disable_input.erase("Move")
		player.disable_input.erase("Pick Up")
		player.disable_input.erase("Interact")
		player.disable_input.erase("Drop")
		
		
		
#		Set up graphics for the menuw
		background.visible = false
		if anim_player:
			anim_player.play("closed")
			player.set_direction(player.direction_name)
			player.set_state("idle")			
		
#		Removes frige from UI node back to it's location in space
		object.get_parent().remove_child(object)
		location_node.add_child(object)
		if collision:
			collision.disabled = false
		object.global_position = object_location
		
		
#	if not is_open:
#		is_open = true
#		background.visible = true
#		player.get_node("UI/LocationUI").scale = ui_scale
#		object_location = global_position
#		get_parent().remove_child(self)
#		player.get_node("UI/LocationUI").add_child(self)
#		position = Vector2.ZERO
#		selector.visible = true
#		player.disable_input += ["Move", "Pick Up", "Drop"]
#		if anim_player:
#			anim_player.play("right")
#		modulate = Color(1, 1, 1, 1)
#		position -= Vector2(ui_offset)
#	elif is_open:
#		is_open = false
#		player.get_node("UI/Background").visible = false
#		var base_node = get_node("/root/Main")
#		get_parent().remove_child(self)
#		if player.held_item:
#			player.hand.add_child(self)
#			position = Vector2.ZERO
#		else:
#			base_node.add_child(self)
#			global_position = object_location
#		selector.visible = false
#		player.disable_input.erase("Move")
#		player.disable_input.erase("Pick Up")
#		player.disable_input.erase("Drop")
#		player.set_direction(player.direction)
#		player.set_state("idle")
