extends FoodTemplate

var food_name = "Potato Salad"
var state = "uncooked"
var cooked = true
var cut = true
var hand
var held = false
var type = "PickUp"
var player
var cook_time = 2
var recipe

func _ready():
	set_item(self)

