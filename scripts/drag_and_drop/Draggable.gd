extends TextureRect
 
@export var content_type:String
var original_texture: Texture2D
var isUsed = false

func _ready():
	original_texture = texture

func _get_drag_data(at_position):
	if isUsed: return false
	get_parent().add_active_drag(self)
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(97,121)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	texture = null
	return self

func when_unsuccesful():
	if isUsed: return
	texture = original_texture

func when_succesful():
	isUsed = true
