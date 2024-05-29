extends "res://scripts/guide/guide_animation.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	$AnimatedSprite2D.play()
	$AnimatedSprite2D2.play()
