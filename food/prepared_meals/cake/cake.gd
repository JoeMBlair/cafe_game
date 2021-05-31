extends FoodTemplate



func _ready():
	set_item(self)
	item_name = "Cake"
	can_cook = true
	cook_time = 2
	cook_temp = 2
	valid_slots += ["Oven"]
