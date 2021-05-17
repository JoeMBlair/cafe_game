extends Area2D

var food_name = "Flour"
var state = "uncooked"
var hand
var held = false
var type = "PickUp"
var player
var cook_time = 2
var recipe


# warning-ignore:unused_argument
func _process(delta):
	if held:
		self.global_position = hand.global_position
	else:
		global_position = global_position


func cook():
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "eat":
		player.remove_item()
		self.queue_free()

