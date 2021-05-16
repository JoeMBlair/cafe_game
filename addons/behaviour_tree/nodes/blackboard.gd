extends Node

var memory := {}

class_name BlackBoard

func _ready():
	pass

func set(key, value, tree := "default"):
	if not memory.has(tree):
		memory[tree] = {}
		
	memory[tree][key] = value
	
func get(key, tree := "default"):
	if memory[tree].has(key):
		return memory[tree][key]
	else:
		return null
	
	return null

