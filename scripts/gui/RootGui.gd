extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pause():
	var pause_screen = Globals.pause_scene.instantiate()
	add_child(pause_screen)
	
func _on_help():
	pass
	
func _on_hint():
	pass
