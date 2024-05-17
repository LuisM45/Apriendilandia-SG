extends Node

var music_volume = 80
var sfx_volume = 80
var tts_volume = 80

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
