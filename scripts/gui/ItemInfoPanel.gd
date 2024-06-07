extends Panel

var selected_item: BackpackItem
@onready var item_title: Label = $ItemTitle
@onready var item_description: Label = $ItemDescription
@onready var icon_texture: TextureRect = $IconTexture
@onready var enable_button: Button = $EnableButton

func reset():
	item_title.text = ""
	item_description.text = ""
	icon_texture.texture = null
	enable_button.disabled = true

func set_item(item:BackpackItem):
	if item == null: 
		reset()
		return
	
	selected_item = item
	enable_button.disabled = false
	item_title.text = item.name
	item_description.text = item.description
	icon_texture.texture = item.get_icon()

func _on_enable_pressed():
	selected_item.enable()
	
