extends Composite

class_name SelectorComposite, "../../icons/selector.svg"

func tick(actor, blackboard):
	for child in get_children():
		var response = [child.tick(actor, blackboard), name]
		if response[0] != FAILED:
			return response[0]
	return FAILED
