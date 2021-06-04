extends FoodBase


func _ready():
	set_item(self)
	item_name = "Butter"
	valid_spaces += ["Frying Pan"]
