extends Control

var msg:String : get = _get_msg, set=_set_msg

@onready var instructionLbl = $VBoxContainer/Panel/InstructionLbl
signal pause()
signal help()
signal hint()

# Called when the node enters the scene tree for the first time.
func _ready():
	size.x =get_viewport().size.x
	position = Vector2(0,0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_pause():
	pause.emit()
	
func _on_help():
	help.emit()
	
func _on_hint():
	hint.emit()

func _set_msg(val):
	instructionLbl.text = val
	
func _get_msg():
	return instructionLbl.text
