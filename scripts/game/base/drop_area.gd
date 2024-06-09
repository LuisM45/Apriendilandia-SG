extends Area2D

const Draggable = preload("res://scripts/game/base/draggable.gd")

signal object_dropped_over(draggable: Draggable)
signal object_lifted_over(draggable: Draggable)

var objects_on = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body is Draggable:
		objects_on[body] = [
			func x(): object_lifted_over.emit(body),
			func x(): object_dropped_over.emit(body),
			]
		if body.is_drag:
			object_lifted_over.emit(body)
			
		body.drag_start.connect(objects_on[body][0])
		body.drag_end.connect(objects_on[body][1])

func _on_body_exited(body):
	if body is Draggable:
		body.drag_start.disconnect(objects_on[body][0])
		body.drag_end.disconnect(objects_on[body][1])
		objects_on.erase(body)
		
