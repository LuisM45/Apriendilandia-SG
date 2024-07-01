extends Node

var current_step = 0.0: set = _set_current_step
var initial_position: Vector2
var final_position: Vector2
var step_size: float
var on_process: Callable

signal edge_reached(is_upper:bool)
signal upper_edge_reached()
signal lower_edge_reached()
signal edge_start(is_upper:bool)
signal upper_edge_start()
signal lower_edge_start()

static func make_autorewind(path):
	path.edge_reached.connect(
		func(_x):path.step_size *= -1
	)
	

func _init(initial_position: Vector2,final_position: Vector2,step_size=1.0,):
	self.initial_position = initial_position
	self.final_position = final_position
	self.step_size = step_size
	self.on_process = func(pos):pass
	edge_reached.connect(_on_edge_reached)
	edge_start.connect(_on_edge_start)

func _process(delta):
	advance_step(delta)
	on_process.call(current_pos())

func current_pos()->Vector2:
	return absolute_pos(current_step)

func reverse_step(step:float)->Vector2:
	current_step -= step*step_size
	return current_pos()

func advance_step(step:float)->Vector2:
	current_step += step*step_size
	return current_pos()
	
func absolute_pos(weight:float)->Vector2:
	assert( false, "ERROR: You have called an unimplemented method")
	return Vector2.ZERO
	
func _set_current_step(new_step):
	if current_step <= 0.0 and new_step>0: edge_start.emit(false)
	if current_step >= 1.0 and new_step<0: edge_start.emit(true)
	current_step = clamp(new_step,0.0,1.0)
	if current_step <= 0.0 and new_step<0: edge_reached.emit(false)
	if current_step >= 1.0 and new_step>0: edge_reached.emit(true)

func _on_edge_reached(is_upper:bool):
	if is_upper: upper_edge_reached.emit()
	else: lower_edge_reached.emit()
	
func _on_edge_start(is_upper:bool):
	if is_upper: upper_edge_start.emit()
	else: lower_edge_start.emit()
