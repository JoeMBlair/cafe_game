extends Node

class_name FoodRecipes

var food_recipes = [{"Name": "Cake", "Recipe": ["Butter", "Flour", "Sugar", "Uncooked Egg"], "Path": "res://food/prepared_meals/cake/cake.tscn"},
					{"Name": "Chocolate Cake", "Recipe": ["Butter", "Chocolate", "Flour", "Uncooked Egg"], "Path": "res://food/prepared_meals/cake/chocolate_cake.tscn"},
					{"Name": "Potato Salad", "Recipe": ["Cut Celery", "Cut Cooked Potato", "Mayo", "Mustard"], "Path": "res://food/prepared_meals/potato_salad/potato_salad.tscn"},
					{"Name": "Mayo", "Recipe": ["Uncooked Egg", "Uncooked Egg", "Uncooked Egg", "Uncooked Egg"], "Path": "res://food/ingredients/mayo/mayo.tscn"},
					{"Name": "Omelette", "Recipe": ["Butter", "Cut Celery", "Uncooked Egg", "Uncooked Egg"], "Path": "res://food/prepared_meals/omelette/omelette.tscn"}]

var food_recipes2 = [{"Name": "Flour", "Recipe": ["Flour"], "Path": "res://food/ingredient/flour/flour.tscn"},
					{"Name": "Flour", "Recipe": ["Flour"], "Path": "res://food/ingredient/flour/flour.tscn"},					
					{"Name": "Flour", "Recipe": ["Flour"], "Path": "res://food/ingredient/flour/flour.tscn"},
					{"Name": "Flour", "Recipe": ["Flour"], "Path": "res://food/ingredient/flour/flour.tscn"}]
	
var cooked_foods = ["res://food/prepared_meals/cake/chocolate_cake.tscn",
					"res://food/cake/cake.tscn"]

func _ready():
	pass
