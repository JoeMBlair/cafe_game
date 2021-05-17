extends FoodTemplate

var food_name = "Chocolate"
var state = "uncut"
var cooked = true
var cut = false
var hand
var held = false
var type = "PickUp"
var player
var cook_time = 2
var recipe

func _ready():
	set_item(self)

