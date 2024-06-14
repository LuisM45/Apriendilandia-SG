extends "res://scripts/game/stage.gd"
@export var rounds = 3
@onready var player = $Player
@onready var maze = $MazeStructure
@onready var playerInitialPos = player.position

const time_baseline = 20
var isMouseCaptured = true

@export var player_sprite_frames: SpriteFrames
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var a: AnimatedSprite2D = $WinArea/AnimatedSprite2D
	player.sprite.sprite_frames = player_sprite_frames
	player.sprite.play("idle")
	a.play("idle")
	new_objetive()

func new_objetive():
	maze.difficulty = int((difficulty-1)/2+3)
	maze.generate()
	var new_player_height = maze.adjusted_tile_size
	player.desired_size = Vector2(new_player_height,new_player_height)
	pass
	
func reset_player():
	player.position = playerInitialPos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("release_capture"):
		toggleMouse()	

func _on_correct_attempt():
	succesful_attempt.emit()
	rounds -= 1
	if rounds <= 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		win.emit("")
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

func _load_customization_config():
	super. _load_customization_config()
	var _maze_tilemap =  Inventory.get_attribute("maze:maze_tilemap")
	var _background_texture =  Inventory.get_attribute("maze:background_texture")
	var _diamond_animated_texture =  Inventory.get_attribute("maze:diamond_animated_texture")
	player_sprite_frames =  Inventory.get_attribute("maze:player_animated_texture")\
		.get_rcontent()
