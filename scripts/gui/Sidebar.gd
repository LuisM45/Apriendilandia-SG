extends Control

var task:Task
var task_format_parm: Dictionary

@onready var instructionLbl = $Panel/InstructionLbl
@onready var help_button = $Panel/VBoxContainer/HelpBtn
signal pause()
signal help()
signal hint()

# Called when the node enters the scene tree for the first time.
func _ready():
	size.x =get_viewport_rect().size.x
	position = Vector2(0,0)
	help_button.guide_scene = task.guide_scene
	help_button.description = task.description.format(task_format_parm)
	help_button.show_dialog = true
	set_task(task)
	
func _on_pause():
	pause.emit()
	
func _on_help():
	var scene = load(task.guide_scene).instantiate()
	scene.task = task
	add_child(scene)
	help.emit()
	
func _on_hint():
	hint.emit()

func set_task(val:Task):
	task = val
	instructionLbl.text = task.name.format(task_format_parm)
	
func _get_task():
	return task
