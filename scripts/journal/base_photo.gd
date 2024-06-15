extends Control
const PhotoDetail = preload("res://branches/journal/detail_photo.tscn")


@export var photo: BackpackItem
@onready var texture_rect = $TextureRect
@onready var name_label = $Label


func _ready():
	texture_rect.texture = photo.get_rcontent()
	name_label.text = photo.name

func _on_pressed():
	var photo_detail = PhotoDetail.instantiate()
	photo_detail.photo = photo
	get_tree().root.add_child(photo_detail)
