extends Node
const Task = preload("res://scripts/game/task.gd")
const Sidebar = preload("res://branches/gui/sidebar.tscn")
	
	
@export_file("*.tscn") var next_scene: String

@export var success_sound: AudioStream
@export var win_sound: AudioStream
@export var bg_music: AudioStream

@export var world: int
@export var stage: int
@export var difficulty: float = 5: set = _set_difficulty
@export var instruction: String

signal pause()
signal resume()
signal attempt(type:int)
signal swin()

var attempts = 0
var mistakes = 0
var hits = 0

var playdate = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_ready_sound()
	playdate = Globals.unix_system_time()
	var gui_node = Sidebar.instantiate()
	add_child(gui_node)
	gui_node.msg = instruction
	gui_node.pause.connect(_on_pause)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _ready_sound():
	var sfx_node = AudioStreamPlayer2D.new()
	var bgm_node = AudioStreamPlayer2D.new()
	bgm_node.stream = bg_music

func _play_success_sound():
	pass

func _play_win_sound():
	pass

func _play_bg_music():
	pass

func win(extra = ""):
	swin.emit()
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
		get_tree().change_scene_to_file(next_scene)
	pass

func _on_pause():
	var pause_screen = Globals.pause_scene.instantiate()
	pause_screen.resume.connect(_on_resume)
	add_child(pause_screen)

func _on_resume():
	resume.emit()
	pass
	
func _on_attempt():
	attempt.emit(0)
	attempts += 1

func _on_failed_attempt():
	attempt.emit(-1)
	attempts += 1
	mistakes += 1
	
func _on_correct_attempt():
	attempt.emit(1)
	attempts += 1
	hits += 1

func _set_difficulty(val):
	difficulty = val
