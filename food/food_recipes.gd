extends Node

class_name FoodRecipes

var food_recipes = [{"Name": "Uncooked Cake", "Recipe": ["Butter", "Egg", "Flour", "Sugar"], "Path": "res://food/cake/cake.tscn"},
					{"Name": "Uncooked Chocolate Cake", "Recipe": ["Butter", "Chocolate", "Egg", "Flour"], "Path": "res://food/cake/chocolate_cake.tscn"},
					{"Name": "Potato Salad", "Recipe": ["Cut Celery", "Cut Cooked Potato", "Mayo", "Mustard"], "Path": "res://food/potato_salad/potato_salad.tscn"}]
var cooked_foods = ["res://food/cake/chocolate_cake.tscn",
					"res://food/cake/cake.tscn"]

func _ready():
	pass
