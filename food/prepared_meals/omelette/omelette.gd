extends FoodBase

func _ready():
	set_item(self)
	item_name = "Omelette"
	can_cook = true
	cook_time = 2
	cook_temp = 2
	valid_spaces += ["Frying Pan"]
