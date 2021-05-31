extends Area2D

class_name ItemBase

var item
var item_name
var item_type
var hand
var held = false
var player
var type = "PickUp"
var valid_slots = []


func _process(delta):
	pass
#	if self:
#		if self.held:
#			self.global_position = hand.global_position
#		else:
#			self.global_position = self.global_position
			
func set_item(new_item):
	item = new_item

func delete():
	pass
	
func valid_item(object, location, action):
	if object.valid_slots.has(location):
		if action == "add":
			return true
		else:
			return false
		
