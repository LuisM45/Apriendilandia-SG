extends Control

const BasePhoto = preload("res://branches/journal/base_photo.tscn")
@onready var photo_container = $VBoxContainer/Panel/HFlowContainer

func _ready():
	var photos = Inventory.get_backpack_photos()
	for photo:BackpackItem in photos:
		var base_photo = BasePhoto.instantiate()
		base_photo.texture_normal = photo.get_rcontent()
		photo_container.add_child(base_photo)

func _on_back_press():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
