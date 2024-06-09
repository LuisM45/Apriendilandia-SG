extends "res://scripts/game/base/drop_area.gd"
const Source = preload("res://scripts/game/mixin/source.gd")
const TextureInfo = preload("res://scripts/game/painting/texture_info.gd")
const CauldronShader = preload("res://resources/unpainted_texture.gdshader")
signal solved()

@export var current_color = Color(.5,.5,.5)
@export var current_texture: TaggedResource: set = _set_current_texture

@onready var texture_node: TextureRect = $Control/TextureRect
var current_source: Source = null
var solve_lock = false
var locked = false
var acceptable_delta = 0.05
var current_weight = 0
const max_weight = 0

func _ready():
	super._ready()

func _process(delta):
	super._process(delta)

func main_color():
	return current_texture.tags.get("main_color")

func _on_source_over(source):
	if solve_lock: return
	current_source = source
	if _pour_source():
		try_solve()
		repaint()
	
func _on_source_removed(source):
	if not source is Source: return
	current_source = null

func repaint():
	var hue_shift = (current_color.h-main_color().h+1)/2
	var saturation_shift = (current_color.s-main_color().s+1)/2
	var value_shift = (current_color.v-main_color().v+1)/2
	texture_node.modulate = Color(hue_shift,saturation_shift,value_shift)

func try_solve():
	var delta_color = current_color-main_color()
	var current_delta = (abs(delta_color.r)+abs(delta_color.g)+abs(delta_color.b))/3
	if current_delta<=acceptable_delta:
		solve_lock = true
		solved.emit()

func _pour_source():
	if current_source and current_source.can_pour():
		current_color = current_source.current_color
		return true
	return false

func _set_current_texture(tagged_resource:TaggedResource):
	current_texture = tagged_resource
	texture_node.texture = tagged_resource.content
