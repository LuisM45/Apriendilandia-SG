extends "res://scripts/game/base/drop_area.gd"
const Source = preload("res://scripts/game/painting/source.gd")
const TextureInfo = preload("res://scripts/game/painting/texture_info.gd")
const CauldronShader = preload("res://resources/unpainted_texture.gdshader")
signal solved()

@export var current_color = Color.from_hsv(0,0,0.8)
@export var texture_info: TextureInfo = load("res://resources/texture_info_default.tres") : set = _set_texture_info

var sprite: Sprite2D
var target_sprite: Sprite2D
var current_source: Source = null
var current_weight = 0
var locked = false
var acceptable_delta = 0.05
const max_weight = 0

func _ready():
	super._ready()
	sprite = append_sprite()
	target_sprite = append_sprite()
	_set_sprites()
	rescale_sprites()
	var _material = ShaderMaterial.new()
	_material.shader = preload("res://resources/unpainted_texture.gdshader")
	sprite.material = 	_material
	

func _process(delta):
	super._process(delta)
	if locked: return
	repaint()
	if _pour_source(delta):
		try_solve()

func _on_source_over(source:Source):
	current_source = source
	
func _on_source_removed(source:Source):
	if not source is Source: return
	current_source = null

func repaint():
	var hue_shift = (current_color.h-texture_info.main_color.h+1)/2
	var saturation_shift = (current_color.s-texture_info.main_color.s+1)/2
	var value_shift = (current_color.v-texture_info.main_color.v+1)/2
	sprite.modulate = Color(hue_shift,saturation_shift,value_shift)

func try_solve():
	var delta_color = current_color-texture_info.main_color
	var current_delta = (abs(delta_color.r)+abs(delta_color.g)+abs(delta_color.b))/3
	if current_delta<=acceptable_delta:
		locked = true
		solved.emit()

func _pour_source(delta):
	if current_source and current_source.can_pour():
		current_color = current_source.current_color
		return true
	return false
	
func append_sprite():
	var sprite = Sprite2D.new()
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)
	return sprite
	
func rescale_sprites():
	var size = texture_info.base_texture.get_size().length()
	var scale_multiplier = 200/size
	sprite.scale = Vector2.ONE*scale_multiplier
	target_sprite.scale = Vector2.ONE*scale_multiplier

func _set_sprites():
	sprite.texture = texture_info.base_texture
	target_sprite.position += Vector2(0,-200)

func _set_texture_info(new):
	texture_info = new
	sprite.texture = new.base_texture
	target_sprite.texture = new.base_texture
	rescale_sprites()
