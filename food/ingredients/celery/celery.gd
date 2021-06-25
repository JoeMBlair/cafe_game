extends FoodBase


func _ready():
	set_item(self)
	item_name = "Celery"
	can_cut = true
	valid_spaces += ["Cutting Board", "Frying Pan"]

