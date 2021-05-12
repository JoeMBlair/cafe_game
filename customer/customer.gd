extends KinematicBody2D

var chairs
var seated = false
var chosen_chair
var vector2vector = Vector2.ZERO
var closet_chair
var direction
var velocity = Vector2.ZERO
var speed = 100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	chairs = get_tree().get_nodes_in_group("Chair")

func _process(delta):
	if not seated:
		if not chosen_chair:
			closet_chair = chairs[0]
			choose_chair()
		if chosen_chair.in_use != self:
			choose_chair()
		if self.global_position.distance_to(closet_chair.global_position) > 2 and not seated:
			vector2vector = closet_chair.global_position - self.global_position
			direction = vector2vector.normalized()
			velocity = direction * 50
			velocity = move_and_slide(velocity)

func choose_chair():
	if not chosen_chair:
		for chair in chairs:
			if not chair.in_use:
				closet_chair = chair
				break
	for chair in chairs:
		if not chair.in_use:
			if chair.global_position.distance_to(self.global_position) < closet_chair.global_position.distance_to(self.global_position):
				closet_chair = chair
	chosen_chair = closet_chair
	closet_chair.in_use = self
