extends Decorator

class_name Inverter, "../../icons/inverter.svg"
func tick(actor, blackboard):
	var child = get_child(0)
	var child_name = child.name
	var response = child.tick(actor, blackboard)
	
	if response == OK:
		return FAILED
	if response == FAILED:
		return OK
	return ERR_BUSY
