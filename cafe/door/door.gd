extends Area2D

onready var scene = load("res://customer/customer.tscn")

func _ready():
	
	pass
	
# warning-ignore:unused_argument
func _process(delta):
	pass
#	debug()


#func debug():
#	if Input.is_action_just_pressed("spawn"):
#		var instance = scene.instance()
#		add_child(instance)
#		instance.global_position = self.global_position
