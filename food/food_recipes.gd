extends Node

class_name FoodRecipes

var food_recipes = {
	"Cake": 
		{
		"Recipe": 
			[
			"Butter", 
			"Flour", 
			"Sugar", 
			"Uncooked Egg"
			], 
		"Cooked": false,
		"Path": "res://food/prepared_meals/cake/cake.tscn"
		},
	"Chocolate Cake": 
		{
		"Recipe": 
			[
			"Butter", 
			"Chocolate", 
			"Flour", 
			"Uncooked Egg"
			],
		"Cooked": false,
		"Path": "res://food/prepared_meals/cake/chocolate_cake.tscn"
		},
	"Potato Salad": 
		{
		"Recipe": 
			[
			"Cut Celery", 
			"Cut Cooked Potato", 
			"Mayo", 
			"Mustard"
			], 
		"Cooked": false,
		"Path": "res://food/prepared_meals/potato_salad/potato_salad.tscn"
		},
	"Omelette": 
		{
		"Recipe": 
			[
			"Butter", 
			"Cut Celery", 
			"Uncooked Egg", 
			"Uncooked Egg"
			], 
		"Cooked": true,
		"Path": "res://food/prepared_meals/omelette/omelette.tscn"
		},
	"Spanish Omelette":
		{
		"Recipe":
			[
				"Cut Celery",
				"Cut Cooked Potato",
				"Uncooked Egg",
				"Uncooked Egg"
			],
		"Cooked": true,
		"Path": "res://food/prepared_meals/spanish_omelette/spanish_omelette.tscn"
		}
	}
var ingredients : Dictionary
var attributes = ["Cut", "Uncut", "Cooked", "Uncooked"]
func _ready():
	var dir = Directory.new()
	if dir.open("res://food/ingredients") == OK:
		dir.list_dir_begin()
		var file_name : String = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var food_name = file_name
				food_name = food_name.capitalize()
				if food_name.find("_"):
					food_name = food_name.replace("_", " ")
				ingredients[food_name] = {}
				var format_path = "res://food/ingredients/%s/%s.tscn"
				var path = format_path % [file_name, file_name]
				ingredients[food_name] = {"Path": path}
			file_name = dir.get_next()
		ingredients.erase(".")
		ingredients.erase("..")
		
		get_ingredients("Potato Salad")
				
				

func random_food():
	randomize()
	var recipes = food_recipes.keys()
	return recipes[rand_range(0, recipes.size())]
	pass


func check_recipe(items, can_cook):
	var object_ingredients : Array
	for item in items:
		object_ingredients += [item.get_stats()]
			
	object_ingredients.sort()
	var recipe_hash = object_ingredients.hash()
	for recipe in food_recipes.keys():
		if food_recipes[recipe].Recipe.hash() == recipe_hash:
			if food_recipes[recipe].Cooked == can_cook:
				return food_recipes[recipe]


func get_ingredients(recipe):
	var recipe_ingredients = food_recipes[recipe]
	var ingredient_objects : Array
	for food_ingredient in recipe_ingredients.Recipe:
		var food_attributes = get_attributes(food_ingredient)
		food_ingredient = remove_attributes(food_ingredient)
		ingredient_objects += [{"Name": food_ingredient,"Attributes": food_attributes, "Cooked": food_recipes[recipe].Cooked, "Path": ingredients[food_ingredient].Path}]
	return ingredient_objects


func get_attributes(ingredient_object):
	pass
	var export_attributes : Array
	for attribute in attributes:
		if attribute in ingredient_object:
			export_attributes += [attribute]
	return export_attributes

func remove_attributes(ingredient_object):
	for attribute in attributes:
		if attribute in ingredient_object:
			ingredient_object = ingredient_object.replace(String(attribute + " "), "")
	return ingredient_object
