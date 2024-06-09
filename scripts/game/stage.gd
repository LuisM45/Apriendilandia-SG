extends Node
const Sidebar = preload("res://branches/gui/sidebar.tscn")
const StageBackground = preload("res://branches/gui/stage_generic_background.tscn")
const Task = preload("res://resources/template/task.gd")
@export_file("*.tscn") var next_scene: String

@export var success_sound: AudioStream = load("res://assets/sfx/90s-game-ui-7-185100.mp3")
@export var win_sound: AudioStream = load("res://assets/sfx/game-bonus-144751.mp3")
@export var bg_music: AudioStream = load("res://assets/bgm/game-music-loop-3-144252.mp3")

@export var world: int
@export var stage: int
@export var difficulty: float = 5: set = _set_difficulty
@export var task: Task

signal pause()
signal resume()
signal attempt(was_succesful:bool)
signal win(extra:String)


var sfx_node: AudioStreamPlayer2D
var bgm_node: AudioStreamPlayer2D
var attempts = 0
var mistakes = 0
var hits = 0

var playdate = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_customization_config(Globals.customization_config)
	_ready_sound()
	_ready_signals()
	playdate = Globals.unix_system_time()
	var gui_node = Sidebar.instantiate()
	gui_node.pause.connect(_on_pause)
	gui_node.help.connect(_on_help)
	add_child(gui_node)
	var background = StageBackground.instantiate()
	add_child(background)
	gui_node.task = task
	if !task.introduction.is_empty():
		DisplayServer.tts_speak(task.introduction.pick_random(),Globals.voice_id,Globals.tts_volume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _ready_signals():
	Globals.volume_changed.connect(_set_sound_volume)
	attempt.connect(_on_attempt)
	attempt.connect(func(x):if x: _play_success_sound())
	win.connect(_on_win)
	win.connect(_play_win_sound)

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
	if !task.outroduction.is_empty():
		DisplayServer.tts_speak(task.outroduction.pick_random(),Globals.voice_id,Globals.tts_volume)
	_play_win_sound()
	var timer = Timer.new()
	add_child(timer)
	
	timer.wait_time = 3
	timer.timeout.connect(func():
		remove_child(timer)
		_on_win_no_timeout(extra)
	)

func _on_win_no_timeout(extra = ""):
	var playtime = Globals.unix_system_time() - playdate
	Database.insert_metric(
		playdate, # playdate
		world, # world
		stage, # stage
		attempts, # attempts
		hits, # corrects
		mistakes, # mistakes
		playtime , # playtime
		extra , # extra
	)
	if next_scene:
		var timer = Timer.new()
		add_child(timer)
		timer.timeout.connect(func ():get_tree().change_scene_to_file(next_scene))
		timer.wait_time = 3.0
		timer.one_shot = true
		timer.start()
		
	pass

func _on_pause():
	var pause_screen = Globals.pause_scene.instantiate()
	pause_screen.resume.connect(_on_resume)
	add_child(pause_screen)

func _on_resume():
	resume.emit()
	pass

func _on_help():
	#var scene = load(guide_scene).instantiate()
	#add_child(scene)
	pass
	

func _on_attempt(was_succesful: bool):
	if was_succesful: _on_correct_attempt()
	else: _on_failed_attempt()

func _on_failed_attempt():
	mistakes += 1
	
func _on_correct_attempt():
	attempts += 1
	hits += 1

func _set_difficulty(val):
	difficulty = val

func _load_customization_config(config_dictionary:Dictionary):
	pass
