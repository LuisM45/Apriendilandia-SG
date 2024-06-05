extends Node

signal volume_changed()

var music_volume = 50 : set = _set_music_volume
var sfx_volume = 80 : set = _set_sfx_volume
var tts_volume = 80 : set = _set_tts_volume

var is_music_enabled = true
var is_sfx_enabled = true
var is_tts_enabled = true

var achievements = {}
var user_data = {}
var backpack_items = []
var customization_config = {}

var voices = DisplayServer.tts_get_voices_for_language("es")
var voice_id = voices[0]

var pause_scene = preload("res://branches/gui/pause_menu.tscn")

func _init():
	load_backpack_items()
	load_customization()
	dev_customization()
	pass

func unix_system_time():
	var sys_time = Time.get_datetime_dict_from_system(true)
	var unix_time = Time.get_unix_time_from_datetime_dict(sys_time)
	return unix_time

func music_volume_db():
	return _parse_volume_to_db(music_volume)

func sfx_volume_db():
	return _parse_volume_to_db(sfx_volume)

func tts_volume_db():
	return _parse_volume_to_db(tts_volume)

func _parse_volume_to_db(volume):
	return 0.3*volume-20

func _set_music_volume(volume):
	music_volume = volume
	volume_changed.emit()

func _set_sfx_volume(volume):
	sfx_volume = volume
	volume_changed.emit()

func _set_tts_volume(volume):
	tts_volume = volume
	volume_changed.emit()

func load_backpack_items():
	const basepath = "res://resources/backpack_items/"
	var dir = DirAccess.open(basepath)
	if !(dir):
		print("resources/backpack_items does not exists")
		return
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir(): continue
		var item:BackpackItem = load(basepath+file_name)
		backpack_items.append(item)
				
		file_name = dir.get_next()

func load_customization():
	for item:BackpackItem in backpack_items:
		if !item.is_default: continue
		print(item)
		enable_item(item)
		
	#SQLcode over here should be.

func enable_item(item:BackpackItem):
	for k in item.get_keys():
		customization_config[k] = item

func get_backpack_item(inner_name:String):
	return load("res://resources/backpack_items/"+inner_name+".tres")

#func dev_enable_backpack_item(inner_name:String):
	#var item = get_backpack_item(inner_name)
	#enable_backpack_item(item)

func dev_customization():
	enable_item(get_backpack_item("background_texture_alt_stripes"))
	enable_item(get_backpack_item("background_accent_color_pgreen"))
	enable_item(get_backpack_item("background_background_color_pblue"))
