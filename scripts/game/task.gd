
signal title_changed(new_title)
signal description_changed(new_description)
signal completed

var title: set = set_title
var description: set = set_description
var isCompleted: set = set_completion

func _init(title,description,isCompleted=false):
	self.title = title
	self.description = description
	self.isCompleted = isCompleted

func set_title(val):
	title_changed.emit(val)
	title = val
	
func set_description(val):
	description_changed.emit(val)
	description = val
	
func set_completion(val):
	if isCompleted: return
	completed.emit()
	isCompleted = val
