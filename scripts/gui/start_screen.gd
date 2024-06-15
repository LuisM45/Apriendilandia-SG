extends Control

const ProfileSelector = preload("res://branches/gui/profile_selector.tscn")
@onready var profile_texture = $ProfileButton/TextureButton

func _ready():
	update_profile_texture()
	Globals.user_changed.connect(update_profile_texture)
	
func update_profile_texture():
	print("achoo")
	var texture = load("res://assets/icons/user.png")
	var texture_res = Inventory.get_attribute("avatar:icon")
	if texture_res != null:
		print("texture_res != null")
		texture = texture_res.get_rcontent()
	profile_texture.texture = texture

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_profile_pressed():
	var pfs = ProfileSelector.instantiate()
	get_tree().root.add_child(pfs)
	pass # Replace with function body.
