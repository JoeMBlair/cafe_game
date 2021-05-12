extends Area2D

var state = "uncooked"
var hand
var held = false
var type = "PickUp"
var player
var cook_time = 2


func _process(delta):
	if held:
		self.global_position = hand.global_position
	else:
		global_position = global_position


func _on_AnimationPlayer_animation_finished(_anim_name):
	player.held_item = null
	self.queue_free()
	pass # Replace with function body.


func _on_Cake_area_entered(area):
	if area.is_in_group("Player") and not held:
		player = area.get_parent()
		player.actions.append(self)


func _on_Cake_area_exited(area):
	if area.is_in_group("Player") and not held:
		player.actions.erase(self)
