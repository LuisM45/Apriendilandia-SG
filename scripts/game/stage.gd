extends Node
const Sidebar = preload("res://branches/gui/sidebar.tscn")
const StageBackground = preload("res://branches/gui/stage_generic_background.tscn")
const UNCOMPLIMENT_CHANCE = 0.3
const COMPLIMENT_CHANCE = 0.6

@export var next_scenes: Array[String] = [] # Wish i knew how to export variables to a packed resouce

@export var unsuccess_sound: AudioStream = load("res://assets/sfx/sadwhisle-91469.mp3")
@export var success_sound: AudioStream = load("res://assets/sfx/90s-game-ui-7-185100.mp3")
@export var win_sound: AudioStream = load("res://assets/sfx/game-bonus-144751.mp3")
@export var bg_music: AudioStream = load("res://assets/bgm/game-music-loop-3-144252.mp3")

@export var world: int
@export var stage: int
@export var difficulty: int = 5
@export var task: Task

signal pause()
signal resume()
signal attempt(was_succesful:bool)
signal succesful_attempt()
signal unsuccesful_attempt()
signal win(extra:String)


var sfx_node: AudioStreamPlayer2D
var bgm_node: AudioStreamPlayer2D
var attempts = 0
var mistakes = 0
var hits = 0

var playdate = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_customization_config()
	_ready_sound()
	_ready_signals()
	difficulty = Globals.difficulty
	playdate = Globals.unix_system_time()
	var gui_node = Sidebar.instantiate()
	gui_node.pause.connect(_on_pause)
	gui_node.help.connect(_on_help)
	gui_node.task = task
	add_child.call_deferred(gui_node)
	
	var background = StageBackground.instantiate()
	add_child(background)
	move_child(background,0)
	if !task.quick_introductions.is_empty():
		DisplayServer.tts_speak(
			task.quick_introductions.pick_random(),
			Globals.voice_id,
			Globals.tts_volume
		)

func _process(_delta):
	pass

func _ready_signals():
	Globals.volume_changed.connect(_set_sound_volume)
	attempt.connect(_on_attempt)
	succesful_attempt.connect(_on_succesful_attempt)
	unsuccesful_attempt.connect(_on_unsuccesful_attempt)
	win.connect(_on_win)
	win.connect(func(_e):_play_win_sound())

func _ready_sound():
	sfx_node = AudioStreamPlayer2D.new()
	bgm_node = AudioStreamPlayer2D.new()
	add_child(sfx_node)
	add_child(bgm_node)
	bgm_node.finished.connect(bgm_node.play) # Prolly problematic, must revise it later
	_set_sound_volume()
	_play_bg_music()

func _set_sound_volume():
	bgm_node.volume_db = Globals.music_volume_db()
	sfx_node.volume_db = Globals.sfx_volume_db()

func _play_unsuccess_sound():
	sfx_node.stream = unsuccess_sound
	sfx_node.play()

func _play_success_sound():
	sfx_node.stream = success_sound
	sfx_node.play()

func _play_win_sound():
	sfx_node.stream = win_sound
	sfx_node.play()

func _play_bg_music():
	bgm_node.stream = bg_music
	bgm_node.play()

func _on_win(extra = ""):
	if !task.quick_out_remarks.is_empty():
		DisplayServer.tts_speak(
			task.quick_out_remarks.pick_random(),
			Globals.voice_id,
			Globals.tts_volume
		)
		
	# Nuevo objeto desbloqueado
	_play_win_sound()
	var unlock_screen = Inventory.try_show_unlock_item()
	if unlock_screen!= null:
		unlock_screen.ok_pressed.connect(_on_win_no_timeout)
		return
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3
	timer.timeout.connect(func():
		remove_child(timer)
		_on_win_no_timeout(extra)
	)
	timer.start()

func _on_win_no_timeout(extra = ""):
	var playtime = Globals.unix_system_time() - playdate
	if !Globals.win_callbacks.is_empty():
		Globals.win_callbacks.pop_front().call()
	Database.insert_metric(
		Globals.user.id, # id
		difficulty, # difficulty
		playdate, # playdate
		world, # world
		stage, # stage
		attempts, # attempts
		hits, # corrects
		mistakes, # mistakes
		playtime , # playtime
		extra , # extra
	)
	if !Globals.next_scenes.is_empty():
		var scene = load(Globals.next_scenes.pop_front())
		get_tree().change_scene_to_packed(scene)
		
	pass

func _on_pause():
	var pause_screen = Globals.pause_scene.instantiate()
	pause_screen.resume.connect(_on_resume)
	get_tree().root.add_child(pause_screen)

func _on_resume():
	resume.emit()
	pass

func _on_help():
	#var scene = load(guide_scene).instantiate()
	#add_child(scene)
	pass
	

func _on_attempt(was_succesful: bool):
	if was_succesful:
		succesful_attempt.emit()
	else:
		unsuccesful_attempt.emit()

func _on_unsuccesful_attempt():
	mistakes += 1
	_play_unsuccess_sound()
	if randf() < UNCOMPLIMENT_CHANCE:
		DisplayServer.tts_speak(
			task.bad_remarks.pick_random(),
			Globals.voice_id,
			Globals.tts_volume
		)
	
func _on_succesful_attempt():
	attempts += 1
	hits += 1
	_play_success_sound()
	if randf() < COMPLIMENT_CHANCE:
		DisplayServer.tts_speak(
			task.compliments.pick_random(),
			Globals.voice_id,
			Globals.tts_volume
		)

func _load_customization_config():
	pass
