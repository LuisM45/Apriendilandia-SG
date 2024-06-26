extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var collision_shape:CollisionShape2D = $CollisionShape2D
@export var dimensions: Vector2i

const speed = 50
var paused = false
var desired_size: Vector2 : set = _set_desired_size
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_input_movement(delta)	
	pass


func set_sprite_frames(sprite_frames:SpriteFrames):
	sprite.sprite_frames = sprite_frames
	_resize_sprite()	
	sprite.play("idle")

func _set_desired_size(size:Vector2):
	desired_size = size
	_resize_sprite()
	_resize_collision()
	
	
func _resize_collision():
	collision_shape.shape.size = sprite\
		.sprite_frames\
		.get_frame_texture("idle",0)\
		.get_size()*sprite.scale*0.6

func _resize_sprite():
	var texture2d_sample:Texture2D = sprite.sprite_frames.get_frame_texture("idle",0)
	var dimension_sample:Vector2 = texture2d_sample.get_size()
	sprite.scale = Vector2.ONE*desired_size.length()/dimension_sample.length()

func _input(event):
	if paused: return
	if event is InputEventMouseMotion:
		velocity = event.relative*speed
		move_and_slide()

func _input_movement(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity=delta*direction*speed*300
	move_and_slide()

func _on_win_area_entered(_body):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_parent().win()
