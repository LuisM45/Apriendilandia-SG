extends Control

@export var backpack_item:BackpackItem

signal ok_pressed()

func _ready():
	set_deferred("size",get_viewport_rect().size)
	$Panel/Button.pressed.connect(_on_ok_pressed)
	$Panel/TextureRect.texture = backpack_item.get_icon()
	$Panel/ItemName.text = backpack_item.name

func _on_ok_pressed():
	ok_pressed.emit()
	queue_free()
