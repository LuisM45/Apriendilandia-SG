extends "res://scripts/game/stage.gd"
@export var rounds = 3
@onready var player = $Player
@onready var maze = $MazeStructure
@onready var playerInitialPos = player.position

const time_baseline = 20
var isMouseCaptured = true
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	new_objetive()

func new_objetive():
	maze.difficulty = difficulty
	maze.generate()
	var new_player_height = maze.adjusted_tile_size*0.6
	var new_player_scale = new_player_height/(player.collision_shape.shape.radius*2)
	print(new_player_scale)
	player.scale = Vector2(new_player_scale,new_player_scale)
	pass
	
func reset_player():
	player.position = playerInitialPos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("release_capture"):
		toggleMouse()	
 
func _input(ev):
	pass

func _on_correct_attempt():
	super._on_correct_attempt()
	rounds -= 1
	if rounds <= 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		super.win()
	reset_player()
	new_objetive()

func toggleMouse():
	isMouseCaptured = !isMouseCaptured
	player.paused = !isMouseCaptured
	if isMouseCaptured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_win_area_body_entered(body):
	if body == player:
		_on_correct_attempt()