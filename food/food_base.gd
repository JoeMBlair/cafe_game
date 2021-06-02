extends ItemBase

class_name FoodTemplate

export var cooked = false
export var cut = false
var cook_time = 1
var can_cook = false
var can_cut = false
var cook_temp = 1
export var burnt = false

func _ready():
	set_item(self)
	set_vars(self)
	item_type = "food"
	valid_slots += ["Mixing Bowl", "Fridge"]

func _process(delta):
	pass
#	if item:
#		if item.held:
#			item.global_position = item.hand.global_position
#		else:
#			item.global_position = item.global_position


func cut():
	item.get_node("AnimatedSprite").animation = "cut"
	item.cut = true


func cook():
	item.cooked = true
	item.get_node("AnimatedSprite").animation = "cooked"
#	item.food_name = String(item.food_name).replace("Uncooked ", "")

func burn():
	item.burnt = true
	item.modulate = Color(0.2, 0.2, 0.2, 1)

func eat():
	item.get_node("AnimationPlayer").play("eat")
	yield(get_tree().create_timer(1), "timeout")
	item.queue_free()
	self.queue_free()

func get_stats(food):
	var food_name = food.item_name
	if food.can_cook:
		if food.cooked:
			food_name = "Cooked " + food_name
		else:
			food_name = "Uncooked " + food_name
	if food.can_cut:
		if food.cut:
			food_name = "Cut " + food_name
		else:
			food_name = "Uncut " + food_name
	return food_name

func set_vars(item):
	if item.cooked:
		cook()
	if item.cut:
		cut()
	if item.burnt:
		burn()


func valid_item(object, location, action):
	if object.item_type == "food":
		if object.valid_slots.has(location):
			if action == "cut" and not object.cut:
				return true
			elif action == "cook" and not object.cooked:
				return true
			elif action == "add":
				return true
	return false
