extends Node2D

func _ready():
	OS.set_window_position(Vector2())

# warning-ignore:unused_argument
func _process(delta):
	debug()


func debug():
	if Input.is_action_just_pressed("Debug"):
# warning-ignore:unused_variable
		var scene = load("res://customer/customer.tscn")
