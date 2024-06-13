extends Control

signal resume()


@onready var music_sld = $MenuPanel/VBox/MusicGroup/MusicSld
@onready var sfx_sld = $MenuPanel/VBox/SfxGroup/SfxSld
@onready var tts_sld =$MenuPanel/VBox/TtsGroup/TtsSld


# Called when the node enters the scene tree for the first time.
func _ready():
	set_deferred("size",get_viewport_rect().size)
	music_sld.value = Globals.music_volume
	sfx_sld.value = Globals.sfx_volume
	tts_sld.value = Globals.tts_volume


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
