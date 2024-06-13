extends Control

func _on_mouse_entered():
	modulate = Color(0.7,0.7,0.7)


func _on_mouse_exited():
	modulate = Color(1.,1.,1.)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_profile_pressed():
	
	pass # Replace with function body.
