extends Node2D

signal finished()

@export var animation: Animation
@export var task:Task


@onready var animation_player:AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("main")
	animation_player.animation_finished.connect(_on_finished)
	if task:
		DisplayServer.tts_speak(task.description,Globals.voice_id,Globals.tts_volume)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_finished(anim_name):
	queue_free()
	finished.emit()
