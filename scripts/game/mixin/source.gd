extends "res://scripts/game/base/draggable.gd"
const mask_shader = preload("res://resources/cauldron_shader.gdshader")

@onready var base_texture_rect: TextureRect = $Control/BaseTextureRect
@onready var mask_texture_rect: TextureRect = $Control/MaskTextureRect

@export var current_color = Color(0,0,0): set = _set_current_color
@export var source_sprite_set:SourceSpriteSet

const weight = 1

func _ready():
	rebound = true
	super._ready()

func _set_current_color(color):
	current_color = color
	if !is_node_ready():
		ready.connect(_remodulate_textures)
		return
	_remodulate_textures()

func _remodulate_textures():
	mask_texture_rect.modulate = current_color

func _ydaer():
	connect_sprite_switch()
	_set_dropped_sprites()

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

func connect_sprite_switch():
	if source_sprite_set.lifted_texture:
		drag_start.connect(_set_lifted_sprites)
		drag_end.connect(_set_dropped_sprites)
		return
	
	drag_start.connect(_rotate_sprites)
	drag_end.connect(_unrotate_sprites)
	
func _set_lifted_sprites():
	base_texture_rect.texture = source_sprite_set.lifted_texture
	mask_texture_rect.texture = source_sprite_set.lifted_color_mask
	
func _set_dropped_sprites():
	base_texture_rect.texture = source_sprite_set.base_texture
	mask_texture_rect.texture = source_sprite_set.base_color_mask

func _rotate_sprites(degrees=45):
	rotation += degrees
	
func _unrotate_sprites(degrees=45):
	rotation -= degrees
	
