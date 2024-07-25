extends Control



func _on_exit_pressed():
	queue_free()


func _on_facebook_pressed():
	OS.shell_open("https://www.facebook.com/LudoLab403/")


func _on_twitter_pressed():
	OS.shell_open("https://x.com/asy_ise")


func _on_www_pressed():
	OS.shell_open("https://polhibou.epn.edu.ec/")
	pass # Replace with function body.


func _on_email_pressed():
	OS.shell_open("mailto:ludolab@epn.edu.ec")
	pass # Replace with function body.


func _on_fis_pressed():
	OS.shell_open("https://fis.epn.edu.ec")
	
func _on_epn_pressed():
	OS.shell_open("https://www.epn.edu.ec/")
