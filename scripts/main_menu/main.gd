extends Control

const PauseMenu = preload("res://branches/gui/pause_menu.tscn")
const InventoryScn = preload("res://branches/gui/inventory.tscn")

@onready var audio_player:AudioStreamPlayer = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.volume_changed.connect(func ():audio_player.volume_db = Globals.music_volume_db())
	audio_player.finished.connect(audio_player.play)
	audio_player.volume_db = Globals.music_volume_db()
	audio_player.play()
	if !Globals.win_callbacks.is_empty():
		Globals.win_callbacks.pop_front().call()
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _load_and_prepare_scenes(scene_lists:Array[String]):
	var _scene_lists = scene_lists.duplicate()
	var scene = load(_scene_lists.pop_front())
	Globals.next_scenes = _scene_lists
	return scene

func _on_button_city_pressed():
	Globals.win_callbacks = [
		Globals.no_fun,
		Globals.no_fun,
		func():Inventory.try_show_unlock_photo("highlands")
	]
	get_tree().change_scene_to_packed(
		_load_and_prepare_scenes([
			"res://scenes/card_matching.tscn",
			"res://scenes/match_numbers.tscn",
			"res://scenes/main_menu.tscn",
		])
	)


func _on_button_beach_pressed():
	Globals.win_callbacks = [
		Globals.no_fun,
		Globals.no_fun,
		func():Inventory.try_show_unlock_photo("coast")
	]
	get_tree().change_scene_to_packed(
		_load_and_prepare_scenes([
			"res://scenes/match_flowers.tscn",
			"res://scenes/paintint_potions.tscn",
			"res://scenes/main_menu.tscn",
		])
	)


func _on_button_forest_pressed():
	Globals.win_callbacks = [
		Globals.no_fun,
		Globals.no_fun,
		Globals.no_fun,
		func():Inventory.try_show_unlock_photo("jungle")
	]
	get_tree().change_scene_to_packed(
		_load_and_prepare_scenes([
			"res://scenes/match_forest.tscn",
			"res://scenes/maze.tscn",
			"res://scenes/mixing_potions.tscn",
			"res://scenes/main_menu.tscn",
		])
	)

func _on_button_config_pressed():
	get_tree().root.add_child(PauseMenu.instantiate())
	pass # Replace with function body.

func _on_inventory_pressed():
	get_tree().root.add_child(InventoryScn.instantiate())

func _on_journal_pressed():
	get_tree().change_scene_to_file("res://scenes/journal.tscn")
