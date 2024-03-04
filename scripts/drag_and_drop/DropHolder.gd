extends TextureRect
 
@export var content_type:String
 
const Draggable = preload("res://scripts/drag_and_drop/Draggable.gd")

func _can_drop_data(_pos, data):
	if data is Draggable:
			return data.content_type == content_type
	return false

func _drop_data(_pos, data):
	texture = data.original_texture
	
