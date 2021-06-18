extends Node2D

func _ready():
	OS.set_window_position(Vector2())
	
func _process(_delta):
	debug()

func debug():
	if Input.is_action_just_pressed("restart"):
		print("restart")
		return  get_tree().reload_current_scene()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
