extends Control

const Task = preload("res://resources/template/task.gd")

var task:Task : get = _get_task, set=_set_task

@onready var instructionLbl = $VBoxContainer/Panel/InstructionLbl
signal pause()
signal help()
signal hint()

# Called when the node enters the scene tree for the first time.
func _ready():
	#size.x =get_viewport().size.x
	position = Vector2(0,0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_pause():
	pause.emit()
	
func _on_help():
	var scene = load(task.guide_scene).instantiate()
	scene.task = task
	add_child(scene)
	help.emit()
	
func _on_hint():
	hint.emit()

func _set_task(val:Task):
	task = val
	instructionLbl.text = task.name
	
func _get_task():
	return task
