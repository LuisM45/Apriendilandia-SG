extends Node
const UnlockScreen = preload("res://branches/gui/unlock_screen.tscn")
const Sidebar = preload("res://branches/gui/sidebar.tscn")
const StageBackground = preload("res://branches/gui/stage_generic_background.tscn")
@export var next_scenes: Array[String] = [] # Wish i knew how to export variables to a packed resouce

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
	add_child(gui_node)
	var background = StageBackground.instantiate()
	add_child(background)
	gui_node.task = task
	if !task.introduction.is_empty():
		DisplayServer.tts_speak(task.introduction.pick_random(),Globals.voice_id,Globals.tts_volume)

func _process(_delta):
	pass

func _ready_signals():
	Globals.volume_changed.connect(_set_sound_volume)
	attempt.connect(_on_attempt)
	attempt.connect(func(x):if x: _play_success_sound())
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
		DisplayServer.tts_speak(
			task.outroduction.pick_random(),
			Globals.voice_id,
			Globals.tts_volume
		)
		
	# Nuevo objeto desbloqueado
	_play_win_sound()
	if _try_unlock(): return
	
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

func _load_customization_config():
	pass

func _try_unlock():
	var unlocked_item = Inventory.pull_random_item()
	if unlocked_item == null: return
	
	Inventory.unlock_item(unlocked_item)
	var ulock_screen = UnlockScreen.instantiate()
	ulock_screen.backpack_item = unlocked_item
	ulock_screen.ok_pressed.connect(_on_win_no_timeout)
	if ulock_screen.backpack_item == null: return false
	
	add_child(ulock_screen)
	return true
