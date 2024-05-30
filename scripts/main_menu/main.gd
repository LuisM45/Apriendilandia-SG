extends Node2D

const PauseMenu = preload("res://branches/gui/pause_menu.tscn")

@onready var audio_player:AudioStreamPlayer = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.volume_changed.connect(func ():audio_player.volume_db = Globals.music_volume_db())
	audio_player.finished.connect(audio_player.play)
	audio_player.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_city_pressed():
	get_tree().change_scene_to_file("res://scenes/maze.tscn")
	pass # Replace with function body.


func _on_button_beach_pressed():
	get_tree().change_scene_to_file("res://scenes/beach_world_1.tscn")
	pass # Replace with function body.


func _on_button_forest_pressed():
	get_tree().change_scene_to_file("res://scenes/mixing_potions.tscn")
	pass # Replace with function body.

func _on_button_config_pressed():
	add_child(PauseMenu.instantiate())
	pass # Replace with function body.
