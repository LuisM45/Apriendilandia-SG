extends CharacterBody2D

@onready var sprite = $Sprite2D
signal starts_drag()
signal ends_drag()

var is_draggable = false
var is_mouse_in = false
var is_enabled = true

func _ready():
	# Need rebound/reset_pos function
	pass # Replace with function body.

func _process(_delta):
	if not is_enabled: return
	object_click()
	object_move()

func object_click():
	if Input.is_action_just_pressed("object_enable") and is_mouse_in:
		starts_drag.emit()
		is_draggable = true
	if Input.is_action_just_released("object_enable"):
		ends_drag.emit()
		is_draggable = false

func object_move():
	if is_draggable:
		position = get_global_mouse_position()

func _on_mouse_exited():
	is_mouse_in = false

func _on_mouse_entered():
	is_mouse_in = true
