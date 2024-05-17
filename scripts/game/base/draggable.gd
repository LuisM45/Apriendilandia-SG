extends CollisionObject2D

signal drag_start()
signal drag_end()

var is_drag = false: set = _set_is_drag
var is_mouse_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_drag:
		position = get_global_mouse_position()
		is_drag = not Input.is_action_just_released("object_enable")
		
func _on_mouse_exited():
	is_mouse_on = false

func _on_mouse_entered():
	is_mouse_on = true

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("object_enable") and is_mouse_on:
		is_drag = true

func _set_is_drag(going_to_drag):
	if not is_drag and going_to_drag: drag_start.emit()
	elif is_drag and not going_to_drag: drag_end.emit()
	is_drag = going_to_drag
