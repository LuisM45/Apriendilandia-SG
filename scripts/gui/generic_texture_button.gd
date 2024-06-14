extends TextureButton

func _init():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_mouse_entered():
	modulate = Color(1.2,1.2,1.2)


func _on_mouse_exited():
	modulate = Color(1.,1.,1.)

func _on_button_down():
	modulate = Color(.8,.8,.8)
	
func _on_button_up():
	_on_mouse_entered()
