extends ApplianceBase

var oven_temp = 0
var hob_temp = 0
var ui_selected = 0
var temp = ["Off", "Low", "Med", "High"]
var ui_open = false
var held_item = {"Oven": null, "Hob": null}
onready var oven_ui = get_node("CanvasLayer/CookerUI/OvenTemp")
onready var hob_ui = get_node("CanvasLayer/CookerUI/HobTemp")


func _ready():
#	object = self
	set_up("Hob", 1)
	set_up("Oven", 1)


func _process(delta):
	if ui_open:
		if ui_selected == 0:
			$CanvasLayer/CookerUI/Selector.position.x = -370
		else:
			$CanvasLayer/CookerUI/Selector.position.x = 20
			
		if Input.is_action_just_pressed("move_up"):
			if ui_selected == 0:
				if oven_temp < 3:
					oven_temp += 1
					oven_ui.text = "Oven: %s" % temp[oven_temp]
			elif ui_selected == 1:
				if hob_temp < 3:
					hob_temp += 1
					hob_ui.text = "| Hob: %s" % temp[hob_temp]
		if Input.is_action_just_pressed("move_down"):
			if ui_selected == 0:
				if oven_temp > 0:
					oven_temp -= 1
					oven_ui.text = "Oven: %s" % temp[oven_temp]
			elif ui_selected == 1:
				if hob_temp > 0:
					hob_temp -= 1
					hob_ui.text = "| Hob: %s" % temp[hob_temp]
		if Input.is_action_just_pressed("move_left"):
			if ui_selected >= 0:
				ui_selected -= 1
		if Input.is_action_just_pressed("move_right"):
			if ui_selected < 1:
				ui_selected += 1


func use(player):
	var player_item = player.held_item
	
	if player_item:
		if held_item.Hob:
			held_item.Hob.use(player)
			return
		if add(player, "Hob", "add", $Hob):
			ui_interact(player)
			ui_selected = 1
			return
		elif add(player, "Oven", "cook", $OvenTray):
			held_item.Oven.visible = false
			ui_interact(player)
			ui_selected = 0
	elif not player_item and get_slots("Oven") and not in_use:
		var oven_item = get_slots("Oven")		
		player.pick_up(remove_item(oven_item[0], "Oven"))
		held_item.Oven.visible = true
		return
	elif not player_item and held_item.Hob:
		var hob_item = get_slots("Hob")
		player.pick_up(remove_item(hob_item[0], "Hob"))
		held_item.Hob = null


func ui_interact(player):
	if not ui_open:
		$CanvasLayer/CookerUI.visible = true
		$CanvasLayer/CookerUI.position.x = 520
		player.disable_input += ["Move", "Pick Up"]
		ui_open = true
#		ui_selected = 0
		
		if held_item.Hob:
			held_item.Hob.scale = Vector2(10, 10)
			held_item.Hob.z_index = 30
			held_item.Hob.get_parent().remove_child(held_item.Hob)
			$CanvasLayer/CookerUI/Hob.add_child(held_item.Hob)
		
		oven_ui.text = "Oven: %s" % temp[oven_temp]
		hob_ui.text = "| Hob: %s" % temp[hob_temp]
		
	else:
		$CanvasLayer/CookerUI.visible = false
		if held_item.Hob:
#			held_item.Hob.hand = $Hob
			held_item.Hob.scale = Vector2(1, 1)
			held_item.Hob.z_index = 30
			held_item.Hob.get_parent().remove_child(held_item.Hob)
			$Hob.add_child(held_item.Hob)
#			held_item.Hob.position = Vector2(0,0)						
		player.disable_input.erase("Move")
		player.disable_input.erase("Pick Up")
		ui_open = false
		if not oven_temp == 0 and held_item.Oven and not held_item.Oven.cooked:
			cook(held_item.Oven)
		oven_temp = 0
		hob_temp = 0
			
			

func add(player, location, action, hand):
	if is_space(location):
		var item = player.held_item
		if item.valid_item(item, location, action):
			var player_food = player.remove_item(player.held_slot)
			pick_up(player_food, location, hand)
			held_item[location] = item
			return true
	return false


func cook(food):
	if food.cook_temp < oven_temp:
		food.burnt = true
		food.modulate = Color(0.2, 0.2, 0.2, 1)
	else:
		$AnimatedSprite.modulate = Color(1, 0, 0)
	in_use = true
	food.global_position = Vector2.ZERO
	$Timer.wait_time = food.cook_time
	$Timer.start()
	return food


func _on_Timer_timeout():
	held_item.Oven.visible = true
	held_item.Oven.modulate = Color(1, 1 , 1, 1)
	held_item.Oven.cook()
	held_item.Oven.global_position = $OvenTray.global_position
	$AnimatedSprite.modulate = Color(1, 1, 1)
	in_use = false

