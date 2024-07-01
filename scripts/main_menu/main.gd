extends Control

const PauseMenu = preload("res://branches/gui/pause_menu.tscn")
const InventoryScn = preload("res://branches/gui/inventory.tscn")
const BasePhoto = preload("res://branches/journal/base_photo.tscn")
const EcuadorTilemap = preload("res://scripts/main_menu/ecuador_tilemap.gd")
const Path = preload("res://scripts/game/object_tracking/paths/export.gd")

@onready var image_container = $PanelContainer/ScrollContainer/ImageContainer
@onready var audio_player:AudioStreamPlayer = $AudioStreamPlayer
@onready var ecuador_tilemap:EcuadorTilemap = $Control/TileMap
@onready var ecuador_tilemap_btn:Button = $Control/Button
@onready var avatar:TextureRect = $Avatar
@onready var city_btn = $ButtonCity
@onready var beach_btn = $ButtonBeach
@onready var forest_btn = $ButtonForest
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.volume_changed.connect(func ():audio_player.volume_db = Globals.music_volume_db())
	reload_avatar_icon()
	audio_player.finished.connect(audio_player.play)
	audio_player.volume_db = Globals.music_volume_db()
	audio_player.play()
	for photo in Inventory.get_backpack_photos():
		var photo_node = BasePhoto.instantiate()
		photo_node.photo = photo
		photo_node.custom_minimum_size = Vector2(200,130)
		photo_node.update_minimum_size()
		image_container.add_child(photo_node)
		
	if !Globals.win_callbacks.is_empty():
		Globals.win_callbacks.pop_front().call()
	
	ecuador_tilemap.layer_clicked.connect(_on_map_pressed)
	
	var avatar_x = Database.get_config_value(Globals.user,"map_avatar_x")
	var avatar_y = Database.get_config_value(Globals.user,"map_avatar_y")
	if avatar_x != null: avatar.position.x=float(avatar_x)
	if avatar_y != null: avatar.position.y=float(avatar_y)
	
	if Database.get_achievement(Globals.user,"intro_done") <= 0:
		play_intro()
	
	config_map()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reload_avatar_icon():
	var avatar_texture = Inventory.get_attribute("avatar:icon")
	if avatar_texture == null: return
	avatar.get_node("AvatarInner").texture = avatar_texture.get_rcontent()
	

func config_map():
	if Database.get_achievement(Globals.user,"free_play") > 0:
		return
		
	var last_region_ulckd = Database.get_achievement(Globals.user,"region_beaten") + 1
	for i in range(1,last_region_ulckd):
		ecuador_tilemap.disable_layer(i)
	for i in range(last_region_ulckd+1,4):
		ecuador_tilemap.disable_layer(i)
	ecuador_tilemap.layer_blink[last_region_ulckd] = true
	
func play_intro():
	$HelpBtn2.pressed.emit()
	Database.set_achievement(Globals.user,"intro_done",1)

func _on_map_pressed(idx):
	match idx:
		1:
			_on_button_beach_pressed()
		2:
			_on_button_city_pressed()
		3:
			_on_button_forest_pressed()
		

func _load_and_prepare_scenes(scene_lists:Array[String]):
	var _scene_lists = scene_lists.duplicate()
	var scene = load(_scene_lists.pop_front())
	Globals.next_scenes = _scene_lists
	return scene

func _on_button_city_pressed():
	
	Globals.win_callbacks = [
		Globals.no_fun,
		Globals.no_fun,
		func():
			Inventory.try_show_unlock_photo("highlands")
			Database.set_achievement(Globals.user,"region_beaten",2)
	]
	var on_place_reached = func():
		Database.set_config_value(Globals.user,"map_avatar_x",str(avatar.position.x))
		Database.set_config_value(Globals.user,"map_avatar_y",str(avatar.position.y))
		get_tree().change_scene_to_packed(
			_load_and_prepare_scenes([
				"res://scenes/card_matching.tscn",
				"res://scenes/match_numbers.tscn",
				"res://scenes/main_menu.tscn",
			])
		)
	
	var path:Path.Path = Path.LinearPath.new(
		avatar.position,
		city_btn.position+Vector2(0,100))
	path.on_process = func (pos): avatar.position = pos
		
	path.upper_edge_reached.connect(on_place_reached)
	add_child(path)
	ecuador_tilemap_btn.disabled = true


func _on_button_beach_pressed():
	Globals.win_callbacks = [
		Globals.no_fun,
		Globals.no_fun,
		func():
			Inventory.try_show_unlock_photo("coast")
			Database.set_achievement(Globals.user,"region_beaten",1)
	]
	
	var on_place_reached = func():
		Database.set_config_value(Globals.user,"map_avatar_x",str(avatar.position.x))
		Database.set_config_value(Globals.user,"map_avatar_y",str(avatar.position.y))
		get_tree().change_scene_to_packed(
		_load_and_prepare_scenes([
			"res://scenes/match_flowers.tscn",
			"res://scenes/paintint_potions.tscn",
			"res://scenes/main_menu.tscn",
		])
	)
	
	var path:Path.Path = Path.LinearPath.new(
		avatar.position,
		beach_btn.position+Vector2(0,100))
	path.on_process = func (pos): avatar.position = pos
		
	path.upper_edge_reached.connect(on_place_reached)
	add_child(path)
	ecuador_tilemap_btn.disabled = true
	
	
	


func _on_button_forest_pressed():
	Globals.win_callbacks = [
		Globals.no_fun,
		Globals.no_fun,
		Globals.no_fun,
		func():
			Inventory.try_show_unlock_photo("jungle")
			Database.set_achievement(Globals.user,"region_beaten",3)
			Database.set_achievement(Globals.user,"free_play",1)
	]
	var on_place_reached = func():
		Database.set_config_value(Globals.user,"map_avatar_x",str(avatar.position.x))
		Database.set_config_value(Globals.user,"map_avatar_y",str(avatar.position.y))
		get_tree().change_scene_to_packed(
			_load_and_prepare_scenes([
				"res://scenes/match_forest.tscn",
				"res://scenes/maze.tscn",
				"res://scenes/mixing_potions.tscn",
				"res://scenes/main_menu.tscn",
			])
		)
	
	var path:Path.Path = Path.LinearPath.new(
		avatar.position,
		forest_btn.position+Vector2(0,100))
	path.on_process = func (pos): avatar.position = pos
		
	path.upper_edge_reached.connect(on_place_reached)
	add_child(path)
	ecuador_tilemap_btn.disabled = true

func _on_button_config_pressed():
	get_tree().root.add_child(PauseMenu.instantiate())
	pass # Replace with function body.

func _on_inventory_pressed():
	var node = InventoryScn.instantiate()
	node.tree_exited.connect(reload_avatar_icon)
	get_tree().root.add_child(node)

func _on_journal_pressed():
	get_tree().change_scene_to_file("res://scenes/journal.tscn")
