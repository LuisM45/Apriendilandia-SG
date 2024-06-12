extends Control

signal resume()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("SfxSld").value = Globals.sfx_volume
	get_node("MusicSld").value = Globals.music_volume
	get_node("TtsSld").value = Globals.tts_volume
	position = get_viewport_rect().size/2


func _on_resume():
	queue_free()
	resume.emit()

func _on_tts_toggle():
	Globals.is_tts_enabled = not Globals.is_tts_enabled

func _on_sfx_toggle():
	Globals.is_sfx_enabled = not Globals.is_sfx_enabled

func _on_music_toggle():
	Globals.is_music_enabled = not Globals.is_music_enabled


func _on_tts_volume_changed(new_volume):
	Globals.tts_volume = new_volume

func _on_sfx_volume_changed(new_volume):
	Globals.sfx_volume = new_volume

func _on_music_volume_changed(new_volume):
	Globals.music_volume = new_volume


func _on_home():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
