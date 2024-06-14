extends BaseButton
const ButtonComposite = preload("res://scripts/gui/button_composite.gd")
const HelpBranch = preload("res://branches/gui/help_branch.tscn")

@export_file("*tscn") var guide_scene
@export_multiline var description:String = ""
@export var show_dialog: bool = true


func _init():
	ButtonComposite.apply(self)
	pressed.connect(_on_pressed)
	
	
func _on_pressed():
	DisplayServer.tts_speak(description,Globals.voice_id,Globals.tts_volume)
	if show_dialog:
		show_message_box()
		return
	
	play_scene()
	tts_read()
	
func play_scene():
	if guide_scene == null: return
	var guide_node = load(guide_scene).instantiate()
	add_child(guide_node)
	
func tts_read():
	DisplayServer.tts_speak(description,Globals.voice_id,Globals.tts_volume)
	
func show_message_box():
	var node = HelpBranch.instantiate()
	node.help_button = self
	node.position = Vector2.ZERO
	get_tree().root.add_child(node)
	#get_tree().root.move_child(node,0)
