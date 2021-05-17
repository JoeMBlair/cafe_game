extends FoodTemplate

var food_name = "Uncooked Cake"
var state = "uncooked"
var hand
var cooked = false
var cut = true
var held = false
var type = "PickUp"
var player
var cook_time = 2
var recipe = ["Butter", "Egg", "Flour", "Sugar"]

func _ready():
	set_item(self)
