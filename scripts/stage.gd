extends Node

static var completed_acts = [false,false,false]
@export_file("*.tscn") var next_scene: String
@export var world_completion: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func win():
	if world_completion > 0:
		completed_acts[world_completion-1] = true
	get_tree().change_scene_to_file(next_scene)
