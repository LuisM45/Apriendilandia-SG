extends Node

var a: int : set = _set_a

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_a(val):
	print("new val:",val)
	a = val
