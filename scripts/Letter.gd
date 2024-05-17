extends Label

const _label_settings = preload("res://resources/beach_label_settings.tres")

var content:String
var index:int

func _init(_content,_index):
	
	content = _content
	index = _index
	text = _content
	
	uppercase = true
	label_settings = _label_settings
	gui_input.connect(_on_gui_input)
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			get_parent().letter_clicked(self)
			

