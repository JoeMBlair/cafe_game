extends Node

class_name FoodRecipes

var food_recipes = [{"Name": "Cake", "Recipe": ["Butter", "Flour", "Sugar", "Uncooked Egg"], "Path": "res://food/prepared_meals/cake/cake.tscn"},
					{"Name": "Chocolate Cake", "Recipe": ["Butter", "Chocolate", "Flour", "Uncooked Egg"], "Path": "res://food/prepared_meals/cake/chocolate_cake.tscn"},
					{"Name": "Chocolate Cake", "Recipe": ["Butter", "Chocolate", "Flour", "Uncooked Egg"], "Path": "res://food/prepared_meals/cake/chocolate_cake.tscn"},					
					{"Name": "Potato Salad", "Recipe": ["Cut Celery", "Cut Cooked Potato", "Mayo", "Mustard"], "Path": "res://food/prepared_meals/potato_salad/potato_salad.tscn"}]
var cooked_foods = ["res://food/prepared_meals/cake/chocolate_cake.tscn",
					"res://food/cake/cake.tscn"]

func _ready():
	pass
