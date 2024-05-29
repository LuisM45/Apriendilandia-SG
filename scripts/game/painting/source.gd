extends "res://scripts/game/base/draggable.gd"
const mask_shader = preload("res://resources/cauldron_shader.gdshader")

var container_sprite: Sprite2D
var mask_sprite = Sprite2D

@export var current_color = Color(0,0,0)
@export var container_texture: Texture2D
@export var color_mask = Texture2D
@export var lifted_container_texture: Texture2D
@export var lifted_color_mask = Texture2D

const weight = 1

func _ready():
	super._ready()
	rebound = true
	container_sprite = append_sprite()
	mask_sprite = append_sprite()
	mask_sprite.modulate = current_color
	connect_sprite_switch()
	_set_dropped_sprites()
	rescale_sprites()
	
func _process(delta):
	super._process(delta)
	pass

func weighted_color():
	return current_color * weight

func can_pour():
	return is_drag

func append_sprite():
	var sprite = Sprite2D.new()
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)
	return sprite

func rescale_sprites():
	var size = container_texture.get_size().length()
	var scale_multiplier = 100/size
	mask_sprite.scale = Vector2.ONE*scale_multiplier
	container_sprite.scale = Vector2.ONE*scale_multiplier

func connect_sprite_switch():
	drag_start.connect(_set_lifted_sprites)
	drag_end.connect(_set_dropped_sprites)
	
func _set_lifted_sprites():
	container_sprite.texture = lifted_container_texture
	mask_sprite.texture = lifted_color_mask
	
func _set_dropped_sprites():
	container_sprite.texture = container_texture
	mask_sprite.texture = color_mask
