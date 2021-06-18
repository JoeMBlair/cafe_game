
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

func _ready():
	set_up("Recipe Book", 1)
	ui_state(false)
	recipes_size = ItemFood.food_recipes.size()
	
func _process(delta):
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

func get_input():
	if Input.is_action_just_pressed("move_left"):
		if selector_index > 0:
			selector_index -= 1
			load_recipe()
	if Input.is_action_just_pressed("move_right"):
		if selector_index < ItemFood.food_recipes.size() - 1:
			selector_index += 1
			load_recipe()


func load_recipe():
	var instructions : String
	page_number.text = "%s/%s" % [selector_index + 1, recipes_size]
#	If there's ingredients shown then clear the recipe book
	if $CanvasLayer/BookUI/Spot0.get_child_count() > 0:
		for i in range(0, 4):
			var spot_children = get_node("CanvasLayer/BookUI/Spot%s" % i).get_children()
			for child in spot_children:
				print(child.queue_free())
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
		
		print(ingredient.Path)
		var ingredient_node = load(ingredient.Path).instance()
		get_node(String("CanvasLayer/BookUI/Spot%s" % count)).add_child(ingredient_node)
		ingredients_names.text += "%s\n" % ingredient.Name
		if ingredient.Attributes.has("Cooked"):
			ingredient_node.cook()
			instructions += "Cook %s\n" % ingredient.Name
		if ingredient.Attributes.has("Cut"):
			var cut_names = ["Cut", "Chop", "Dice"]
			ingredient_node.cut()
			instructions += "%s %s\n" % [cut_names[rand_range(0, cut_names.size())], ingredient.Name]
			
		ingredient_node.modulate = Color(1, 1, 1, 0.7)
		count += 1
		
	if ingredients[0].Cooked == false:
		instructions += "Add all ingredients to the bowl\n"
		if prepared_food.can_cook:
			instructions += "Cook %s in the oven" % recipes[selector_index]
	else:
		instructions += "Add all ingredients to the frying pan\n"
		
	recipe_instructions.bbcode_text = instructions
			
		
