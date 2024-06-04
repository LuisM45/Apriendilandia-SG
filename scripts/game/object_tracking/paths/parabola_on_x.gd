extends "res://scripts/game/object_tracking/paths/path.gd"

var a:float
var b:float
var direction_vector: Vector2
var normal_vector: Vector2
var delta_lenght: float

func _init(initial_position: Vector2,final_position: Vector2,arc_height:float,step_size=1.0):
	super._init(initial_position,final_position,step_size)
	var delta = (final_position - initial_position)
	delta_lenght = delta.length()
	direction_vector = delta.normalized()
	normal_vector = direction_vector.orthogonal()
	b = 4*arc_height/delta_lenght
	a = -b/delta_lenght
	

func absolute_pos(weight:float)->Vector2:
	var linear_component = initial_position.lerp(final_position,current_step)
	var quadratic_component = normal_vector*_parabola_on_axis(weight*delta_lenght)
	return linear_component+quadratic_component

func _parabola_on_axis(x:float):
	return a*x*x+b*x
