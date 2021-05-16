extends BehaviourTree

onready var blackboard = BlackBoard.new()
onready var child = self.get_child(0)
onready var actor = get_parent()
export (bool) var enabled = true

class_name BehaviourTreeRoot, "../icons/tree.svg"

func _ready():
	pass


func _process(delta):
	if not enabled:
		return
	blackboard.set("delta", delta)
	child.tick(actor, blackboard)

func enable():
	enabled = true
	
func disable():
	enabled = false


