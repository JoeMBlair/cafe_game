extends ToolBase

var dirty = false
onready var anim_sprite = get_node("PlateObject/AnimatedSprite")

func _ready():
	selector = $Select
	collision = $CollisionShape2D
	ui_location = self
	tool_object = $PlateObject
	set_item(self)
	var food_spots = $PlateObject/FoodSpots.get_children()
	set_up("Plate", food_spots.size(), {"Spot": food_spots})
	item_name = "Plate"
	item_type = "tool"
	valid_spaces += ["Table", "Sink"]


func _process(_delta):
	pass


func make_dirty():
	dirty = true
	anim_sprite.animation = "dirty"


func make_clean():
	dirty = false
	anim_sprite.animation = "clean"

func use(player):
	if ObjectUI.is_open:
		var food_space = item_space(ObjectUI.space_select)
		if food_space["Item"]:
			remove_item(food_space, "Plate", player.hand)	
	elif add(player, "Plate", "add"):
		return

