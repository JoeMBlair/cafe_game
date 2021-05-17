extends FoodTemplate

var food_name = "Flour"
var state = "uncut"
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

