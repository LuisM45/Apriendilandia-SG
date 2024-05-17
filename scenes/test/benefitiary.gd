extends "res://scenes/test/inheritance.gd"



# Called when the node enters the scene tree for the first time.
func _ready():
	a = 33
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	a += 2
	pass

func _set_a(val):
	print("overriden: ",val)
