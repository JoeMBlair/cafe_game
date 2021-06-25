extends FoodBase


func _ready():
	set_item(self)
	item_name = "Egg"
	can_cook = true
	cook_time = 2
	valid_spaces += ["Frying Pan", "Pot"]
