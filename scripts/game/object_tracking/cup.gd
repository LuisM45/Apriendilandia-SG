extends CharacterBody2D

signal on_click(_self)
signal finished_moving()
signal path_finished(path:Path)
signal all_path_finished()

const Path = preload("res://scripts/game/object_tracking/paths/path.gd")
const LinearPath = preload("res://scripts/game/object_tracking/paths/linear_path.gd")
const NoPath = preload("res://scripts/game/object_tracking/paths/no_path.gd")

var speed = 1
var path_queue: Array[Path] = []
var content: Node2D

func _ready():
	input_event.connect(_on_input_event)
	pass # Replace with function body.

func _process(delta):
	traverse_path(delta)
	
func traverse_path(delta):
	if path_queue.is_empty(): return
	position = path_queue[0].advance_step(delta*speed)

func current_path():
	if path_queue.is_empty(): return null
	return path_queue[0]
	
func append_path(path:Path,callback=func():pass):
	path_queue.append(path)
	path.edge_reached.connect(_on_finished_path)
	path.edge_reached.connect(func(a):callback.call())
	pass

func expected_last_pos():
	if path_queue.is_empty(): return position
	return path_queue[-1].final_position

func _on_finished_path(is_upper):
	if not is_upper: return
	var path = path_queue.pop_front()
	path_finished.emit(path)
	if path_queue.is_empty(): all_path_finished.emit()

func lift(distance=100):
	var path = LinearPath.new(expected_last_pos(),expected_last_pos()+Vector2(0,-distance))
	if content != null:
		path.lower_edge_start.connect(func(): content.visible=true)
	append_path(path)
	
func lower(distance=100):
	var path = LinearPath.new(expected_last_pos(),expected_last_pos()-Vector2(0,-distance))
	if content != null:
		path.upper_edge_reached.connect(func(): content.visible=false)
	append_path(path)
	
	


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		print(content.visible)
		on_click.emit(self)
