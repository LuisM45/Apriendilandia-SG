extends Node

signal volume_changed()

var music_volume = 0 : set = _set_music_volume
var sfx_volume = 80 : set = _set_sfx_volume
var tts_volume = 80 : set = _set_tts_volume

var is_music_enabled = true
var is_sfx_enabled = true
var is_tts_enabled = true

var achievements = {}
var user_data = {}

var pause_scene = preload("res://branches/gui/pause_menu.tscn")


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
	return 0.4*volume-35

func _set_music_volume(volume):
	volume_changed.emit()
	music_volume = volume

func _set_sfx_volume(volume):
	volume_changed.emit()
	sfx_volume = volume

func _set_tts_volume(volume):
	volume_changed.emit()
	tts_volume = volume
