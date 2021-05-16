tool
extends StaticBody2D

export(String, "front", "back", "left", "right") var directions
onready var sprite = get_node("AnimatedSprite")
export(NodePath) var in_use


# warning-ignore:unused_argument
func _process(delta):
	pass
	if directions != $AnimatedSprite.animation:
		$AnimatedSprite.animation = directions

