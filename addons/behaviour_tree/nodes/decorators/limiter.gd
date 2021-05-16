extends Decorator

class_name Limiter, "../../icons/limiter.svg"

export (float) var max_count = 0
var current_count = 0

func tick(actor, blackboard):
	if current_count <= max_count:
		current_count += 1
		return get_child(0).tick(actor, blackboard)
	pass
	return FAILED
