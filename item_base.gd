extends Area2D

class_name ItemBase

var item
var item_name
var item_type
var held = false
#var player
var type = "PickUp"
var valid_slots = []


func _process(delta):
	pass


func set_item(new_item):
	item = new_item
	


func delete(slot, location):
#	var item = remove_item(slot, location)
	item.queue_free()
	pass
	
func valid_item(object, location, action):
	if object.valid_slots.has(location):
		if action == "add":
			return true
		else:
			return false
		
