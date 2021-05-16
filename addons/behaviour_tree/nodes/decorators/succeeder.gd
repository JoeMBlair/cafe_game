extends Decorator

class_name AlwaysSucceed, "../../icons/succeed.svg"
func tick(actor, blackboard):
	for child in get_children():
		var response = child.tick(actor, blackboard)
		if response == ERR_BUSY:
			return ERR_BUSY
		return OK
