extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_city_pressed():
	get_tree().change_scene_to_file("res://scenes/city_world_1.tscn")
	pass # Replace with function body.


func _on_button_beach_pressed():
	get_tree().change_scene_to_file("res://scenes/beach_world_1.tscn")
	pass # Replace with function body.


func _on_button_forest_pressed():
	get_tree().change_scene_to_file("res://scenes/forest_world_1.tscn")
	pass # Replace with function body.
