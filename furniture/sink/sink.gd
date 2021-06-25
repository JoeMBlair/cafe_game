extends ApplianceBase

var sink_inventory
var is_open = false
var space_select = 0
onready var anim_sprite = get_node("AnimatedSprite")
#var locations = {"board": get_node("DetectorBoard"), "bowl": get_node("DetectorBowl")}

func _ready():
	set_up("Sink", 1, {"Spot": [get_node("Spot")]})
	selector = $Selector
	ui_scale = Vector2(20, 20)
	ui_offset = Vector2(0, -10)

func use(player):
	use_sink(player)


func use_sink(player):
	var player_item = player.held_item
	var sink_item = get_spaces("Sink", "Item")
	if player_item and add(player, "Sink", "add", $Sink):
		sink_item = get_spaces("Sink", "Item")
		return
		#	Checks if you can cut the ingredient if true then it cuts it up
	elif not player.held_item and sink_item.size() != 0:
		if sink_item[0].dirty:
			sink_item[0].make_clean()
			anim_sprite.animation = "on"
		else:
			anim_sprite.animation = "off"			
			var sink_space = get_spaces("Sink")
			sink_space = sink_space[0]
			player.pick_up(remove_item(sink_space, "Sink"), player.location_name(), player.hand)

func ui_interact(player):
	pass

func remove_food(item_spot, location):
	var item = item_spot.Item
	remove_item(item_spot, location)
	return item
