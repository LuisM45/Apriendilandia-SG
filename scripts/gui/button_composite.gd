
var button:BaseButton

static func apply(_button:BaseButton):
	return new(_button)

func _init(_button:BaseButton):
	button = _button
	button.mouse_entered.connect(func():_on_mouse_entered())
	button.mouse_exited.connect(func():_on_mouse_exited())
	button.button_down.connect(func():_on_button_down())
	button.button_up.connect(func():_on_button_up())
	
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	button.button_down.connect(_on_button_down)
	button.button_up.connect(_on_button_up)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_mouse_entered():
	button.modulate = Color(1.2,1.2,1.2)


func _on_mouse_exited():
	button.modulate = Color(1.,1.,1.)

func _on_button_down():
	button.modulate = Color(.8,.8,.8)
	
func _on_button_up():
	_on_mouse_entered()
