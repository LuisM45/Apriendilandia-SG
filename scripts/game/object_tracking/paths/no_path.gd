extends "res://scripts/game/object_tracking/paths/path.gd"

#Useful as a placeholder or when no movement is required but still needs a path
func _init(position: Vector2,step_size=1.0):
	super._init(position,position,step_size)

func absolute_pos(weight:float)->Vector2:
	return initial_position
