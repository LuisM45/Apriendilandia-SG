extends TextureRect
 
@export var content_type:String

func _get_drag_data(at_position):
	var preview_texture = TextureRect.new()
 
	preview_texture.texture = texture
	preview_texture.expand_mode = 0
	preview_texture.size = Vector2(77,182)
 
	var preview = Control.new()
	preview.add_child(preview_texture)
 
	set_drag_preview(preview)
	texture = null
 
	return preview_texture.texture
 
 
func _can_drop_data(_pos, data):
	return data is Texture2D
 
 
func _drop_data(_pos, data):
	texture = data

