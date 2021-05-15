extends Node2D

func _ready():
	OS.set_window_position(Vector2())

func _process(delta):
	debug()


func debug():
	if Input.is_action_just_pressed("Debug"):
		var scene = load("res://customer/customer.tscn")
