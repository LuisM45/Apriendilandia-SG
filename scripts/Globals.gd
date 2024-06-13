extends Node

signal volume_changed()

var music_volume = 50 : set = _set_music_volume
var sfx_volume = 80 : set = _set_sfx_volume
var tts_volume = 80 : set = _set_tts_volume

var is_music_enabled = true
var is_sfx_enabled = true
var is_tts_enabled = true



var voices = DisplayServer.tts_get_voices_for_language("es")
var voice_id = voices[0]
var user:User

var pause_scene = preload("res://branches/gui/pause_menu.tscn")
var next_scenes = []
func _init():
	if !Database.is_node_ready(): await Database.ready
	load_volume_from_db()
	user = User.new()
	user.id = 0
	user.username = "default"
	#var utils = load("res://scripts/utils.gd").new()
	#utils.export_backpack_items()
	pass

func load_volume_from_db():
	var db_music_volume = Database.get_config_value("music_volume")
	if db_music_volume != null: music_volume = int(db_music_volume)
	
	var db_sfx_volume = Database.get_config_value("sfx_volume")
	if db_sfx_volume != null: sfx_volume = int(db_sfx_volume)
	
	var db_tts_volume = Database.get_config_value("tts_volume")
	if db_tts_volume != null: tts_volume = int(db_tts_volume)
	
	var db_is_music_enabled = Database.get_config_value("is_music_enabled")
	if db_is_music_enabled != null: is_music_enabled = bool(int(db_is_music_enabled))
	
	var db_is_sfx_enabled = Database.get_config_value("is_sfx_enabled")
	if db_is_sfx_enabled != null: is_sfx_enabled = bool(int(db_is_sfx_enabled))
	
	var db_is_tts_enabled = Database.get_config_value("is_tts_enabled")
	if db_is_tts_enabled != null: is_tts_enabled = bool(int(db_is_tts_enabled))

func load_user_from_db():
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
	Database.set_config_value("music_volume",str(volume))
	music_volume = volume
	volume_changed.emit()

func _set_sfx_volume(volume):
	Database.set_config_value("sfx_volume",str(volume))
	sfx_volume = volume
	volume_changed.emit()

func _set_tts_volume(volume):
	Database.set_config_value("tts_volume",str(volume))
	tts_volume = volume
	volume_changed.emit()


	
