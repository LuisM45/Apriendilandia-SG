extends Area2D
@onready var sprite = $Sprite2D
var last_body = null
var is_mouse_in = false

signal object_dropped_within(body)
# Called when the node enters the scene tree for the first time.

func _process(_delta):
	if Input.is_action_just_released("object_enable")\
		and is_mouse_in\
		and last_body!=null:
		object_dropped_within.emit(last_body)

func _on_body_entered(body):
	last_body = body

func _on_mouse_exited():
	is_mouse_in = false

func _on_mouse_entered():
	is_mouse_in = true
