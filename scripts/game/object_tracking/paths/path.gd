
var current_step = 0.0: set = _set_current_step
var initial_position: Vector2
var final_position: Vector2

signal edge_reached(is_upper:bool)

func _init(initial_position: Vector2,final_position: Vector2):
	self.initial_position = initial_position
	self.final_position = final_position
	
func current_pos()->Vector2:
	return absolute_pos(current_step)

func reverse_step(step:float)->Vector2:
	current_step -= step
	return current_pos()

func advance_step(step:float)->Vector2:
	current_step += step
	return current_pos()
	
func absolute_pos(weight:float)->Vector2:
	assert( false, "ERROR: You have called an unimplemented method")
	return Vector2.ZERO
	
func _set_current_step(new_step):
	current_step = clamp(new_step,0.0,1.0)
	if current_step <= 0.0: edge_reached.emit(false)
	if current_step >= 1.0: edge_reached.emit(true)
