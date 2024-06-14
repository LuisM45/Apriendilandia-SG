extends BaseButton
const ButtonComposite = preload("res://scripts/gui/button_composite.gd")

@export_file("*tscn") var deploy_scene
@export_multiline var description:String = ""
@export var show_dialog: bool = true


func _init():
	ButtonComposite.apply(self)
	pressed.connect(_on_pressed)
	
	
func _on_pressed():
	if deploy_scene != null:
		var packed = load(deploy_scene)
		if packed != null:
			add_child(packed.instantiate())
	
	DisplayServer.tts_speak(description,Globals.voice_id,Globals.tts_volume)
	if show_dialog: show_message_box()

func show_message_box():
	pass
