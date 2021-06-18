extends FoodBase


func _ready():
	set_item(self)
	item_name = "Spanish Omelette"
	can_cook = true
	cook_time = 3
	cook_temp = 2
	valid_spaces += ["Frying Pan"]
