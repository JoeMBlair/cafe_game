tool
extends StaticBody2D

export(String, "front", "back", "left", "right") var directions
onready var sprite = get_node("AnimatedSprite")
var in_use


func _process(delta):
	pass
	if directions != $AnimatedSprite.animation:
		$AnimatedSprite.animation = directions
		


func _on_SitPoint_body_entered(body):
	if body.is_in_group("Customer"):
		body.seated = true
		body.global_position = $SitPoint.global_position
