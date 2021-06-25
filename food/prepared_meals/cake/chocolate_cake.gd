extends FoodBase


func _ready():
	item_name = "Chocolate Cake"
	can_cook = true
	cook_time = 3
	valid_spaces += ["Oven"]
	cook_temp = 2

