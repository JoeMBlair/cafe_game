extends FoodBase

func _ready():
	set_item(self)
	item_name = "Potato"
	can_cook = true
	can_cut = true
	valid_spaces += ["Oven", "Cutting Board"]
