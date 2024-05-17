extends Node
@export var base_sprite: Texture2D : set = _set_sprite
@onready var original_body = get_node("original_body")
@onready var shadow_body = get_node("shadow_body")

signal correct_match(body)
signal incorrect_match(body)

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _set_sprite(new_val:Texture2D):
	base_sprite = new_val
	original_body.sprite.set_texture(new_val)
	shadow_body.sprite.set_texture(new_val)
	if base_sprite == null: return
	
	var size_magnitude = new_val.get_size().length()
	
	original_body.sprite.scale /= size_magnitude/200
	shadow_body.sprite.scale /= size_magnitude/200
	
func _attempt_complete(body):
	if original_body == body:
		original_body.position = shadow_body.position
		original_body.is_enabled = false
		correct_match.emit(body)
	else:
		incorrect_match.emit(body)
