extends FoodTemplate

func _ready():
	set_item(self)
	item_name = "Egg"
	can_cook = true
	cook_time = 2
	valid_slots += ["Frying Pan", "Pot"]
#extends Area2D
