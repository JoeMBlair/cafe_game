extends ApplianceBase

var oven_inventory
var hob_inventory
var temp_level = 0
var ui_selected = 1
var oven_temp = ["Off", "Low", "Medium", "High"]
var ui_open = false
var held_item = {"Oven": null, "Hob": null}

func _ready():
	object = self
	inventory = {"Oven": [], "Hob": []}
	oven_inventory = inventory["Oven"]
	hob_inventory = inventory["Hob"]
	set_up("Hob", 1)
	set_up("Oven", 1)


func _process(delta):
	if ui_open:
		if Input.is_action_just_pressed("move_up"):
			if temp_level < 3:
				temp_level += 1
				$CanvasLayer/CookerUI/Temp.text = "Temp: %s" % oven_temp[temp_level]				
		if Input.is_action_just_pressed("move_down"):
			if temp_level > 0:
				temp_level -= 1
				$CanvasLayer/CookerUI/Temp.text = "Temp: %s" % oven_temp[temp_level]				


func use(player):
	var player_item = player.held_item
	
	if player_item:
		if held_item.Hob:
			held_item.Hob.use(player)
			return
		if add(player, "Hob", "add", $Hob):
			return
		elif add(player, "Oven", "cook", $OvenTray):
			held_item.Oven.visible = false
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
	if not $CanvasLayer/CookerUI.visible:
		if held_item.Hob:
#			held_item.Hob.hand = $CanvasLayer/CookerUI/Hob
			held_item.Hob.scale = Vector2(10, 10)
			held_item.Hob.z_index = 30
			held_item.Hob.get_parent().remove_child(held_item.Hob)
			$CanvasLayer/CookerUI/Hob.add_child(held_item.Hob)
#			held_item.Hob.position = Vector2(0,0)						
		$CanvasLayer/CookerUI.visible = true
		$CanvasLayer/CookerUI.position.x = 520
		player.disable_input += ["Move", "Pick Up"]
		ui_open = true
		$CanvasLayer/CookerUI/Temp.text = "Temp: %s" % oven_temp[temp_level]
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
		if not temp_level == 0 and held_item.Oven and not held_item.Oven.cooked:
			cook(held_item.Oven)
		temp_level = 0
			
			

func add(player, location, action, hand):
	if is_space(location):
		var item = player.held_item
		if item.valid_item(item, location, action):
			var player_food = player.remove_item()
			pick_up(player_food, location, hand)
			held_item[location] = item
			return true
	return false


func cook(food):
	if food.cook_temp < temp_level:
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

