extends CharacterBody2D

signal finished_moving()
const Path = preload("res://scripts/game/object_tracking/paths/path.gd")

var speed = 1
var pending_path:Path = null : set = _set_pending_path

func _ready():
	pass # Replace with function body.

func _process(delta):
	traverse_path(delta)
	
func traverse_path(delta):
	if pending_path == null: return
	position = pending_path.advance_step(delta*speed)
	
func _set_pending_path(new_path:Path):
	pending_path = new_path
	
	if new_path == null: return
	pending_path.edge_reached.connect(_on_finished_path)

func _on_finished_path(is_upper):
	if not is_upper: return
	pending_path = null
