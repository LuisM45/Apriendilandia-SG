extends "res://scripts/game/base/drop_area.gd"
const Source = preload("res://scripts/game/mixin/source.gd")
signal solved()
signal got_reset()

@export var current_color = Color.GRAY: set = _set_current_color
@export var target_color = Color(250,100,100): set = _set_target_color
@export var container_texture: Texture2D
@export var color_mask = Texture2D

var sprite: Sprite2D
var mask_sprite: Sprite2D
var target_sprite: Sprite2D
var target_mask_sprite: Sprite2D
var current_source: Source = null

var solve_lock = false
var locked = false

var acceptable_delta = 0.05
var current_weight = 0
var max_weight = 2

func _ready():
	super._ready()
	sprite = append_sprite()
	mask_sprite = append_sprite()
	target_sprite = append_sprite()
	target_mask_sprite = append_sprite()
	_set_sprites()
	rescale_sprites()

func _process(delta):
	super._process(delta)

func weighted_color():
	return current_color*current_weight

func _on_source_over(source:Source):
	if solve_lock: return
	current_source = source
	if _pour_source():
		try_solve()
	
func _on_source_removed(source:Source):
	if not source is Source: return
	current_source = null

func _set_current_color(color:Color):
	current_color = color
	mask_sprite.modulate =color

func _set_target_color(color:Color):
	print(target_color)
	target_color = color
	target_mask_sprite.modulate = target_color


func try_solve():
	var delta_color = current_color-target_color
	var current_delta = (abs(delta_color.r)+abs(delta_color.g)+abs(delta_color.b))/3
	if current_delta<=acceptable_delta:
		solve_lock = true
		solved.emit()
		
	if(current_weight>=max_weight):
		reset_cauldron()	

func reset_cauldron():
	got_reset.emit()
	locked = true
	var t = Timer.new()
	t.wait_time = 1
	t.timeout.connect(func():
		current_weight = 0
		current_color = Color.GRAY
		remove_child(t)
	)
	add_child(t)
	t.start()
	

func _pour_source():
	if current_source and current_source.can_pour():
		var _weight = float(current_source.weight) / float(current_weight+current_source.weight)
		current_color = ColorLib.combine_color_pair(current_source.current_color,current_color,_weight)
		current_weight = min(max_weight,current_weight+current_source.weight)
		return true
	return false

func append_sprite():
	var _sprite = Sprite2D.new()
	_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(_sprite)
	return _sprite
	
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
	target_sprite.position += Vector2(200,-90)
	target_mask_sprite.position += Vector2(200,-90)
