extends Area2D

class_name ItemBase

var item
var item_name
var item_type
var held = false
var type = "PickUp"
var valid_spaces = []


func _process(_delta):
	pass


func set_item(new_item):
	item = new_item

func use(player):
	pass

func valid_item(object, location, action):
	if object.valid_spaces.has(location):
		if action == "add":
			return true
		else:
			return false

