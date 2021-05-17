extends Area2D

class_name FoodTemplate

var item

func _process(delta):
	if item:
		if item.held:
			item.global_position = item.hand.global_position
		else:
			item.global_position = item.global_position


func set_item(new_item):
	item = new_item


func cut():
	item.get_node("AnimatedSprite").animation = "cut"
	item.cut = true
	item.food_name = "Cut " + item.food_name


func cook():
	item.cooked = true
	item.get_node("AnimatedSprite").animation = "cooked"
	item.food_name = String(item.food_name).replace("Uncooked", "Cooked")


func eat():
	item.get_node("AnimationPlayer").play("eat")
	yield(get_tree().create_timer(1), "timeout")
	item.queue_free()
	self.queue_free()
