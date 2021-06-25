extends ApplianceBase

var is_open = false
var selector_index = 0
onready var ui_sprite = get_node("CanvasLayer/BookUI")
onready var ui_background = get_node("CanvasLayer/Background")
onready var recipe_name = get_node("CanvasLayer/BookUI/PageRight/RecipeName")
onready var recipe_instructions = get_node("CanvasLayer/BookUI/PageRight/RecipeInstructions")
onready var ingredients_names = get_node("CanvasLayer/BookUI/PageLeft/IngredientNames")
onready var page_number = get_node("CanvasLayer/BookUI/PageRight/PageNumber")
onready var prepared_spot = get_node("CanvasLayer/BookUI/PageRight/SpotPrepared")
var recipes = ItemFood.food_recipes.keys()
var recipes_size
var current_page
var held_item
var held_space
onready var hand = get_node("AnimatedSprite")

func _ready():
	set_up("Recipe Book", 1)
	set_up("Recipe Storage", 5)
	ui_state(false)
	recipes_size = ItemFood.food_recipes.size()


func _process(_delta):
	if is_open:
		get_input()


func ui_interact(player):
	if not is_open:
		ui_state(true)
		player.disable_input += ["Move", "Pick Up", "Interact", "Drop"]
		load_recipe()
	else:
		ui_state(false)
		player.disable_input.erase("Move")
		player.disable_input.erase("Pick Up")
		player.disable_input.erase("Interact")
		player.disable_input.erase("Drop")
	pass


func ui_state(state):
	is_open = state
	if is_open:
		ui_sprite.visible = true
		ui_background.visible = true
		is_open = true
		load_recipe()
	else:
		ui_sprite.visible = false
		ui_background.visible = false
		is_open = false



func load_recipe():
	var instructions : String
	var recipe_steps = []
	page_number.text = "%s/%s" % [selector_index + 1, recipes_size]
#	If there's ingredients shown then clear the recipe book
	if $CanvasLayer/BookUI/Spot0.get_child_count() > 0:
		for i in range(0, 4):
			var spot_children = get_node("CanvasLayer/BookUI/Spot%s" % i).get_children()
			for child in spot_children:
				child.queue_free()
		var prepared_children = prepared_spot.get_children()
		
		for child in prepared_children:
			child.queue_free()
	
	
	var ingredients = ItemFood.get_ingredients(recipes[selector_index])
	recipe_name.bbcode_text = "[center]%s[center]" % recipes[selector_index]
	var prepared_food = load(ItemFood.food_recipes[recipes[selector_index]].Path).instance()
	prepared_spot.add_child(prepared_food)
	if ItemFood.food_recipes[recipes[selector_index]].Cooked == false:
		prepared_food.cook()
	prepared_food.modulate = Color(1, 1, 1, 0.7)
	var count = 0
	ingredients_names.text = ""
	for ingredient in ingredients:
		var command 
#		print(ingredient.Path)
		var ingredient_node = load(ingredient.Path).instance()
		get_node(String("CanvasLayer/BookUI/Spot%s" % count)).add_child(ingredient_node)
		ingredients_names.text += "%s\n" % ingredient.Name
		var commands = []
		if ingredient.Attributes.has("Cooked"):
			ingredient_node.cook()
			instructions += "Cook %s\n" % ingredient.Name
			commands += ["Cook"]
			recipe_steps += [{"Command": "Cook", "Ingredient": ingredient_node}]
			
		if ingredient.Attributes.has("Cut"):
			var cut_names = ["Cut", "Chop", "Dice"]
			ingredient_node.cut()
			instructions += "Cut %s\n" % ingredient.Name
			commands += ["Cut"]
			
		recipe_steps += [{"Commands": commands, "Ingredient": ingredient_node}]
			
			
		ingredient_node.modulate = Color(1, 1, 1, 0.7)
		count += 1
		
	if ingredients[0].Cooked == false:
		instructions += "Add all ingredients to the bowl\n"
		recipe_steps += [{"Commands": ["Add"], "Object": "MixingBowl"}]
		if prepared_food.can_cook:
			instructions += "Cook %s in the oven" % recipes[selector_index]
			recipe_steps += [{"Commands": ["Cook"], "Recipe": recipes[selector_index]}]
	else:
		instructions += "Add all ingredients to the frying pan\n"
		recipe_steps += [{"Commands": ["Add"], "Object": "FryingPan"}]
		
		
	current_page = {"Name": recipes[selector_index], "Steps": recipe_steps}
	recipe_instructions.bbcode_text = instructions
	print(recipe_steps)

func get_input():
	if Input.is_action_just_pressed("move_left"):
		if selector_index > 0:
			selector_index -= 1
			load_recipe()
	if Input.is_action_just_pressed("move_right"):
		if selector_index < ItemFood.food_recipes.size() - 1:
			selector_index += 1
			load_recipe()
	if Input.is_action_just_pressed("Debug"):
		make_food()


func make_food():
	var recipe_ingredients = []
	for step in current_page.Steps:
		var ingredient_node
		if step.has("Ingredient"):
			ingredient_node = get_food(step.Ingredient)
			recipe_ingredients += [ingredient_node]
		if step.has("Object"):
			pass
		if step.has("Recipe"):
			pass
		if step.Commands.has("Cook"):
			var object = get_tree().get_nodes_in_group("Cooker")
			var removed_item = remove_item(item_space(0), "Recipe Storage")			
			pick_up(removed_item, "Recipe Book", $AnimatedSprite)
			held_item = ingredient_node
			held_space = item_space(0, "Recipe Book")
			object = object[0]
			object.use(self)
			object.cook(ingredient_node, 1)
#			yield(object.get_node("Timer"), "timeout")
			object.use(self)
			removed_item = remove_item(item_space(0), "Recipe Book")			
			pick_up(removed_item, "Recipe Storage", hand)
			
		if step.Commands.has("Cut"):
			var object = get_tree().get_nodes_in_group("ChoppingBoard")
			var removed_item = remove_item(item_space(0), "Recipe Storage")			
			pick_up(removed_item, "Recipe Book", $AnimatedSprite)
			held_item = ingredient_node
			held_space = item_space(0, "Recipe Book")
			object = object[0]
			print(get_spaces("Recipe Book"))
			for i in range(0, 3):
				object.use(self)
#				yield(get_tree().create_timer(0.5), "timeout")	
			removed_item = remove_item(item_space(0), "Recipe Book")
			pick_up(removed_item, "Recipe Storage", hand)
		
		if step.Commands.has("Add"):
			pass
			
		print(step)
		pass

func get_food(food):
	
	var fridge = get_tree().get_nodes_in_group("Fridge")
	fridge = fridge[0]
	var food_space = fridge.get_space(food.item_name, "Fridge")
	var location = "Fridge"
	if not food_space:
		food_space = fridge.get_space(food.item_name, "Fridge Door")
		location = "Fridge Door"
	elif food_space:
		var food_index = food_space["Space Index"]
		var ingredient_node = fridge.remove_item(food_space, location)
		if pick_up(ingredient_node, "Recipe Storage", $AnimatedSprite):
			held_item = ingredient_node
			held_space = item_space(0, "Recipe Book")
			return ingredient_node

func remove_item(space, location = inv.default_location, hand = null):
	var remove_result = .remove_item(space, location, hand)
	if remove_result:
		held_item = null
		held_space = null
		return remove_result
