
var dictionary = {}

func _init():
	pass
	
func put(key,value):
	if dictionary.get(key) == value: return
	dictionary[key] = value
	return value
