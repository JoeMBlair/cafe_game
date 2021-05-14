extends Area2D

var food_name = "Chocolate Cake"
var state = "uncooked"
var hand
var held = false
var type = "PickUp"
var player
var cook_time = 3


func _process(delta):
	if held:
		self.global_position = hand.global_position
	else:
		global_position = global_position


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "eat":
		player.held_item = null
		self.queue_free()

