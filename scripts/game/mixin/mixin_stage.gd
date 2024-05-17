extends "res://scripts/game/stage.gd"

const Cauldron = preload("res://scripts/game/mixin/cauldron.gd")
@onready var cauldrons = $Cauldrons.get_children() as Array[Cauldron]

# Called when the node enters the scene tree for the first time.
var remaining = 0
func _ready():
	super._ready()
	remaining = cauldrons.size()
	for cauld in cauldrons:
		cauld.acceptable_delta = 0.10 - difficulty * 0.01
		cauld.solved.connect(_on_solved)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func _on_solved():
	remaining -= 1
	attempt.emit(true)
	if remaining<=0: win.emit("")
