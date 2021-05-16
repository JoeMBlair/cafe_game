extends Composite

class_name SequenceComposite, "../../icons/sequence.svg"
export var debug = false
func tick(actor, blackboard):
	
	if get_child_count() != 0:
		for child in get_children():
			var child_name = child.name
			var response = [child.tick(actor, blackboard), name]
			if response[0] != OK:
				return response[0]
		return OK
	
	
