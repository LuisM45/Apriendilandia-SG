extends "res://scripts/game/object_tracking/paths/path.gd"

func _init(initial_position: Vector2,final_position: Vector2):
	super._init(initial_position,final_position)

func absolute_pos(weight:float)->Vector2:
	return initial_position.lerp(final_position,current_step)
