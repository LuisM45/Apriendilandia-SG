extends Node

var active_drags = []
var remaining_items = 3

func add_active_drag(draggable):
	active_drags.push_back(draggable)

func drag_end():
	while active_drags.size() > 0:
		var active = active_drags.pop_back()
		if(!active.is_drag_successful()):
			active.when_unsuccesful()
		else:
			remaining_items -= 1
			active.when_succesful()			
	
	if remaining_items == 0:
		get_parent().win()

func _notification(type):
	if type == NOTIFICATION_DRAG_END: drag_end()
