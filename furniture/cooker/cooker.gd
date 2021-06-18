extends ApplianceBase

var oven_temp = 0
var hob_temp = 0
var ui_selected = 0
var ui_controls = [oven_temp, hob_temp]
var temp = ["Off", "Low", "Med", "High"]
var ui_open = false
var held_item = {"Oven": null, "Hob": null}
onready var oven_ui = get_node("CanvasLayer/CookerUI/Node2D/OvenTemp")
onready var hob_ui = get_node("CanvasLayer/CookerUI/Node2D/HobTemp")


func _ready():
	set_up("Hob", 1)
	set_up("Oven", 1)


func _process(_delta):
	if ui_open:
		if ui_selected == 0:
			$CanvasLayer/CookerUI/Selector.position.x = 148
			if oven_temp == 3:
				$CanvasLayer/CookerUI/Selector/Indicator.text = "  >"
			elif oven_temp == 0:
				$CanvasLayer/CookerUI/Selector/Indicator.text = "<  "
			else:
				$CanvasLayer/CookerUI/Selector/Indicator.text = "< >"
		else:
			$CanvasLayer/CookerUI/Selector.position.x = 10
			if hob_temp == 3:
				$CanvasLayer/CookerUI/Selector/Indicator.text = "  >"
			elif hob_temp == 0:
				$CanvasLayer/CookerUI/Selector/Indicator.text = "<  "
			else: 
				$CanvasLayer/CookerUI/Selector/Indicator.text = "< >"
			
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
			if ui_selected == 1:
				ui_selected = 0
			else:
				ui_selected = 1
		if Input.is_action_just_pressed("move_right"):
			if ui_selected == 1:
				ui_selected = 0
			else:
				ui_selected = 1


func use(player):
	var player_item = player.held_item
	
	if player_item:
		if held_item.Hob:
			held_item.Hob.use(player)
			return
		if add(player, "Oven", "cook", $OvenTray):
			var items = get_spaces("Oven")
			held_item.Oven = items[0]["Item"]
#			held_item.Oven.visible = false
			ui_interact(player)
			ui_selected = 0
		elif add(player, "Hob", "add", $Hob):
			var items = get_spaces("Hob")
			held_item.Hob = items[0]["Item"]
			player_item.anim_player.play("right")			
			ui_selected = 1
			return
	elif not player_item and get_spaces("Oven") and not in_use:
		var oven_item = get_spaces("Oven")		
		player.pick_up(remove_item(oven_item[0], "Oven"))
		$OvenDoor.animation = "closed"
		return
	elif not player_item and held_item.Hob:
		var hob_item = get_spaces("Hob")
		player.pick_up(remove_item(hob_item[0], "Hob"))
		held_item.Hob = null


func ui_interact(player):
	if not ui_open:
		yield(.get_tree().create_timer(0.1), "timeout")
		$CanvasLayer/CookerUI.visible = true
		$CanvasLayer/CookerUI.position.x = 260
		player.disable_input += ["Move", "Pick Up"]
		ui_open = true
		
		if held_item.Hob:
			held_item.Hob.z_index = 30
			held_item.Hob.get_parent().remove_child(held_item.Hob)
			$CanvasLayer/CookerUI/Hob.add_child(held_item.Hob)
		
		oven_ui.text = "Oven: %s" % temp[oven_temp]
		hob_ui.text = "| Hob: %s" % temp[hob_temp]
	else:
		$CanvasLayer/CookerUI.visible = false
		if held_item.Hob:
			held_item.Hob.z_index = 30
			held_item.Hob.get_parent().remove_child(held_item.Hob)
			$Hob.add_child(held_item.Hob)
		player.disable_input.erase("Move")
		player.disable_input.erase("Pick Up")
		ui_open = false
		if ui_selected == 0 and held_item.Oven and not oven_temp == 0:
			if not oven_temp == 0 and not held_item.Oven.is_cooked:
				cook(held_item.Oven, oven_temp)
				$OvenLight.visible = true
				yield($Timer, "timeout")
				$OvenLight.visible = false				
#				$AnimatedSprite.modulate = Color.white
				$OvenDoor.animation = "open"
		elif ui_selected == 1 and held_item.Hob and not hob_temp == 0:
			var spaces = held_item.Hob.get_spaces()
			if spaces.size() == 4:
				mix(held_item.Hob, true, held_item.Hob.location_name())
				spaces = held_item.Hob.get_spaces()
				var food = spaces[0]["Item"]
				if not hob_temp == 0 and food and not food.is_cooked:
					held_item.Hob.get_node("FryingPanObject/Cooking").visible = true
					held_item.Hob.modulate = Color.red
					cook(food, hob_temp)
					yield($Timer, "timeout")
					held_item.Hob.get_node("FryingPanObject/Cooking").visible = false
					held_item.Hob.modulate = Color.white
		oven_temp = 0
		hob_temp = 0


func cook(food, appliance_temp):
	in_use = true
	$Timer.wait_time = food.cook_time
	$Timer.start()
	yield($Timer, "timeout")
	food.cook()
	if food.cook_temp < appliance_temp:
		food.burn()
	in_use = false
	food.visible = true
	return food


func _on_Timer_timeout():
	pass

