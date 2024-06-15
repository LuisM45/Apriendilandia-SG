extends Control

var photo: BackpackItem

@onready var image_texture = $TextureRect
@onready var title_label = $Panel/VBoxContainer/Label
@onready var description_label = $Panel/VBoxContainer/Label2

func _ready():
	image_texture.texture = photo.get_rcontent()
	title_label.text = photo.name
	description_label.text = photo.description

func _on_back_pressed():
	queue_free()

func _on_tts_pressed():
	DisplayServer.tts_speak(
		photo.name,
		Globals.voice_id,
		Globals.tts_volume
	)
	
	DisplayServer.tts_speak(
		photo.description,
		Globals.voice_id,
		Globals.tts_volume
	)
