extends Resource
class_name Achievement

const Comparator = preload("res://resources/template/comparator.gd")

signal completed(action)

@export var inner_name: String
@export var name: String
@export_multiline var description: String
var conditions : Dictionary

func check(action):
	for property:String in conditions.keys():
		var comparator:Comparator = conditions[property]
		var value = action[property]
		var is_condition_satisfied = comparator.compare(value)
		if not is_condition_satisfied:
			return false
	
	completed.emit(action)
	return true
