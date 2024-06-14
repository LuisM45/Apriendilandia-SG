extends Node

var base_sprite: TaggedResource : set = _set_sprite
@onready var original_body = get_node("original_body")
@onready var shadow_body = get_node("shadow_body")

signal correct_match(body)
signal incorrect_match(body)

func _ready():
	shadow_body.object_dropped_within.connect(_attempt_complete)
	pass # Replace with function body.

func _process(_delta):
	pass

func _set_sprite(new_val:TaggedResource):
	base_sprite = new_val
	var content = null
	if new_val != null: content = new_val.content
	original_body.sprite.set_texture(content)
	shadow_body.sprite.set_texture(content)
	if base_sprite == null: return
	
	var size_magnitude = new_val.content.get_size().length()
	
	original_body.sprite.scale /= size_magnitude/200
	shadow_body.sprite.scale /= size_magnitude/200
	
func _attempt_complete(body):
	print("_attempt_complete")
	if original_body == body:
		original_body.position = shadow_body.position
		original_body.is_enabled = false
		DisplayServer.tts_speak(base_sprite.tags["alt_text"],Globals.voice_id,Globals.tts_volume)
		correct_match.emit(body)
	else:
		incorrect_match.emit(body)
