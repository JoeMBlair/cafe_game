extends FoodTemplate

var food_name = "Celery"
var state = "uncut"
var cooked = false
var cut = false
var hand
var held = false
var type = "PickUp"
var player
var cook_time = 2
var recipe

func _ready():
	set_item(self)
# warning-ignore:unused_argument
#func _process(delta):
#	if held:
#		self.global_position = hand.global_position
#	else:
#		global_position = global_position
#
#
#func cut():
#	$AnimatedSprite.animation = "cut"
#	state = "cut"
#	food_name = "Cut Celery"
#
#func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "eat":
#		player.remove_item()
#		self.queue_free()

