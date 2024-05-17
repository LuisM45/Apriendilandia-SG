extends "res://scripts/game/base/drop_area.gd"
const Source = preload("res://scripts/game/mixin/source.gd")
signal solved()

@export var current_color = Color(100,100,100)
@export var target_color = Color(250,100,100)
@export var container_texture: Texture2D
@export var color_mask = Texture2D

var sprite: Sprite2D
var mask_sprite: Sprite2D
var target_sprite: Sprite2D
var target_mask_sprite: Sprite2D
var current_source: Source = null
var current_weight = 50
var locked = false
var acceptable_delta = 0.05
const max_weight = 500

func _ready():
	super._ready()
	current_color = Color(randf(),randf(),randf())
	target_color = Color(randf(),randf(),randf())
	sprite = append_sprite()
	mask_sprite = append_sprite()
	target_sprite = append_sprite()
	target_mask_sprite = append_sprite()
	_set_sprites()
	rescale_sprites()
	mask_sprite.modulate = current_color
	target_mask_sprite.modulate = target_color

func _process(delta):
	super._process(delta)
	if locked: return
	if _pour_source():
		try_solve()
	mask_sprite.modulate = current_color

func weighted_color():
	return current_color*current_weight

func _on_source_over(source:Source):
	current_source = source
	
func _on_source_removed(source:Source):
	if not source is Source: return
	current_source = null



func try_solve():
	var delta_color = current_color-target_color
	var current_delta = (abs(delta_color.r)+abs(delta_color.g)+abs(delta_color.b))/3
	print(current_delta)
	if current_delta<=acceptable_delta:
		locked = true
		solved.emit()

func _pour_source():
	if current_source and current_source.can_pour():
		current_color = ( weighted_color() + current_source.weighted_color() ) / (current_weight+current_source.weight)
		current_weight = min(max_weight,current_weight+current_source.weight)
		return true
	return false
	
func append_sprite():
	var sprite = Sprite2D.new()
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)
	return sprite
	
func rescale_sprites():
	var size = container_texture.get_size().length()
	var scale_multiplier = 200/size
	mask_sprite.scale = Vector2.ONE*scale_multiplier
	sprite.scale = Vector2.ONE*scale_multiplier
	target_sprite.scale = Vector2.ONE*scale_multiplier
	target_mask_sprite.scale = Vector2.ONE*scale_multiplier

func _set_sprites():
	sprite.texture = container_texture
	mask_sprite.texture = color_mask
	target_sprite.texture = container_texture
	target_mask_sprite.texture = color_mask
	target_sprite.position += Vector2(0,-200)
	target_mask_sprite.position += Vector2(0,-200)
