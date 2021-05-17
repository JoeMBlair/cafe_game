extends FoodTemplate

var food_name = "Uncooked Chocolate Cake"
var state = "uncooked"
var hand
var cooked = false
var cut = true
var held = false
var type = "PickUp"
var player
var cook_time = 3
var recipe = ["Butter","Chocolate", "Egg", "Flour"]

func _ready():
	set_item(self)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "eat":
		player.held_item = null
		self.queue_free()

