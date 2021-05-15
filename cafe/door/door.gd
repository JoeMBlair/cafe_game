extends Area2D

onready var scene = load("res://customer/customer.tscn")

func _ready():
	
	pass
	
func _process(delta):
	debug()


func debug():
	if Input.is_action_just_pressed("Debug"):
		var instance = scene.instance()
		add_child(instance)
		instance.global_position = self.global_position
