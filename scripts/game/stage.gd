extends Node

@export_file("*.tscn") var next_scene: String

@export var world: int
@export var stage: int
@export var difficulty: float: set = _set_difficulty

var attempts = 0
var mistakes = 0
var hits = 0

var playdate = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	playdate = Globals.unix_system_time()
	var gui_node = load("res://branches/gui/sidebar.tscn").instantiate()
	add_child(gui_node)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func win(extra = ""):
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
	add_child(pause_screen)

func _on_resume():
	pass
	
func _on_attempt():
	attempts += 1

func _on_failed_attempt():
	attempts += 1
	mistakes += 1
	
func _on_correct_attempt():
	attempts += 1
	hits += 1

func _set_difficulty(val):
	difficulty = val
