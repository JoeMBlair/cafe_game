tool
extends StaticBody2D

export(String, "front", "back", "left", "right") var directions setget set_rotation
onready var anim_player = get_node("AnimationPlayer")
export(NodePath) var in_use


# warning-ignore:unused_argument
func _process(delta):
	pass

func set_rotation(direction):
	$AnimationPlayer.play(direction)
	directions = direction
