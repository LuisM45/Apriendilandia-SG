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
var current_weight = 0
var solve_lock = false
var locked = false
var acceptable_delta = 0.05
const max_weight = 2

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
	
	mask_sprite.modulate = current_color

func weighted_color():
	return current_color*current_weight

func _on_source_over(source:Source):
	current_source = source
	if _pour_source():
		try_solve()
	
func _on_source_removed(source:Source):
	if not source is Source: return
	current_source = null



func try_solve():
	var delta_color = current_color-target_color
	var current_delta = (abs(delta_color.r)+abs(delta_color.g)+abs(delta_color.b))/3
	if current_delta<=acceptable_delta:
		locked = true
		solved.emit()

func _pour_source():
	if current_source and current_source.can_pour():
		var _weight = float(current_source.weight) / float(current_weight+current_source.weight)
		current_color = dirty_combine_colors(current_color,current_source.current_color,_weight)
		current_weight = min(max_weight,current_weight+current_source.weight)
		return true
	return false

func dirty_combine_colors(color1:Color,color2:Color,weight):
	var rect_hs_1 = Vector2(color1.h,color1.h)*2*PI
	rect_hs_1.x = cos(rect_hs_1.x)
	rect_hs_1.y = sin(rect_hs_1.y)
	rect_hs_1 *= color1.s
	
	var rect_hs_2 = Vector2(color2.h,color2.h)*2*PI
	rect_hs_2.x = cos(rect_hs_2.x)
	rect_hs_2.y = sin(rect_hs_2.y)
	rect_hs_2 *= color2.s
	
	var rect_hs_x = rect_hs_1.lerp(rect_hs_2,weight)
	var v = weight*color1.v + (1-weight)*color2.v
	
	var h = rect_hs_x.angle()/(2*PI)
	h += 1 if h <=0 else 0
	var s = rect_hs_x.length()
	return Color.from_hsv(h,s,v)

func combine_colors(color1:Color,color2:Color,weight):
	# It hurts having to write this. Ouch, my naming standards
	#if color1.h > color2.h: return combine_colors(color2,color1,1-weight)
	var alpha = (color1.h - color2.h)*2*PI
	var s1 = color1.s
	var s2 = color2.s
	
	var aSqr = compute_a_squared(s1,s2,alpha)
	var a = sqrt(aSqr)
	var cos_S2 = compute_cos_S2(s1,s2,a)
	var ax = compute_ax(a,weight)
	
	var sxSqr = compute_sx_squared(s1,ax,cos_S2)
	var sx = sqrt(sxSqr)
	
	var alpha_x = compute_alpha_x(ax,s1,sx)

	var hx = (color1.h + alpha_x)/2*PI
	var vx = color1.v*weight + color2.v*(1-weight)
	print(color1.h,",",color1.s,",",color1.v)
	print(color2.h,",",color2.s,",",color2.v)
	print(hx,",",sx,",",vx)
	return Color.from_hsv(hx,sx,vx)
	
func compute_a_squared(s1,s2,alpha):
	return s1*s1+s2*s2-2*s1*s2*cos(alpha)

func compute_cos_S2(s1,s2,a):
	return (s2*s2-s1*s1-a*a)/(2*s1*a)

func compute_ax(a,ratio):
	return a*ratio

func compute_sx_squared(s1,ax,cos_s2):
	return s1*s1+ax*ax-2*s1*ax*cos_s2

func compute_alpha_x(ax,s1,sx):
	return acos(-(ax*ax-s1*s1-sx*sx)/(2*s1*sx))

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
