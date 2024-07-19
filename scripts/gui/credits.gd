extends Control



func _on_exit_pressed():
	queue_free()


func _on_facebook_pressed():
	OS.shell_open("https://www.facebook.com/LudoLab403/")
