extends ItemBase

class_name FoodBase

export var is_cooked = false
export var is_cut = false
var cook_time = 1
var can_cook = false
var can_cut = false
var cook_temp = 1
export var burnt = false

func _ready():
	set_item(self)
	set_vars(self)
	item_type = "food"
	valid_spaces += ["Mixing Bowl", "Fridge", "Plate"]


func cut():
	item.get_node("AnimatedSprite").animation = "cut"
	item.is_cut = true


func cook():
	item.is_cooked = true
	item.get_node("AnimatedSprite").animation = "cooked"
	item.modulate = Color(1, 1 , 1, 1)


func burn():
	item.burnt = true
	item.modulate = Color(0.2, 0.2, 0.2, 1)


func eat():
	item.get_node("AnimationPlayer").play("eat")
	yield(get_tree().create_timer(1), "timeout")
	item.queue_free()
	self.queue_free()


func get_stats():
	var food = self
	var food_name = food.item_name
	if food.can_cook:
		if food.is_cooked:
			food_name = "Cooked " + food_name
		else:
			food_name = "Uncooked " + food_name
	if food.can_cut:
		if food.is_cut:
			food_name = "Cut " + food_name
		else:
			food_name = "Uncut " + food_name
	return food_name


func set_vars(item):
	if item.is_cooked: cook()
	if item.is_cut: cut()
	if item.burnt: burn()


func valid_item(location, action):
	if item_type == "food":
		if valid_spaces.has(location):
			match action:
				"cut": if not is_cut: return true
				"cook": if not is_cooked: return true
				"add": return true
	return false
