extends FoodTemplate


func _ready():
#	set_item(self)
	item_name = "Chocolate Cake"
	can_cook = true
	cook_time = 3
	valid_slots += ["Oven"]
	cook_temp = 2

func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "eat":
#		player.held_item = null
#		self.queue_free()
	pass

