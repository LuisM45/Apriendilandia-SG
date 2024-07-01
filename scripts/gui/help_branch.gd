extends Control

@onready var description_label = $Panel/VBoxContainer/ScrollContainer/Label
@onready var tts_button = $Panel/VBoxContainer/HBoxContainer/TtsButton
@onready var clacker_button = $Panel/VBoxContainer/HBoxContainer/ClackerButton

const CompositeButton = preload("res://scripts/gui/button_composite.gd")
const HelpButton = preload("res://scripts/gui/help_button.gd")
var help_button: HelpButton

func _ready():
	description_label.text = help_button.description
	CompositeButton.apply(tts_button)
	CompositeButton.apply(clacker_button)
	if help_button.guide_scene != null:
		clacker_button.visible = true
	
func _on_clacker_pressed():
	help_button.play_scene()

func _on_tts_pressed():
	help_button.tts_read()
	
func _on_ok_pressed():
	queue_free()
