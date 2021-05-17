extends FoodTemplate

var food_name = "Mustard"
var state = "uncooked"
var hand
var cooked = true
var cut = true
var held = false
var type = "PickUp"
var player
var cook_time = 2
var recipe

func _ready():
	set_item(self)

