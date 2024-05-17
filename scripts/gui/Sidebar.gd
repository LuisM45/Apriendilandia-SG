extends Control

var msg = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	size.x =get_viewport().size.x
	position = Vector2(0,0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_pause():
	get_parent()._on_pause()
	
func _on_help():
	get_parent()._on_help()
	
func _on_hint():
	get_parent()._on_hint()
