extends "res://scripts/guide/guide_animation.gd"

@export_flags("Lifted") var bottle_1_states = 0 : set = _set_bottle_1_states
@export_flags("Lifted") var bottle_2_states = 0 : set = _set_bottle_2_states

@export var lifted_texture: Texture2D
@export var lifted_color: Texture2D
@export var grounded_texture: Texture2D
@export var grounded_color: Texture2D
@export var mouse_content: NodePath : set = _set_mouse_content
var _mouse_content: Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

func _process(delta):
	super._process(delta)
	_mouse_sticky()
	#reposition_sticky_nodes()

func _set_bottle_1_states(new_state):
	bottle_1_states = new_state
	var color_sprite = $StickyNodes/Bottle_1/Color
	var base_sprite = $StickyNodes/Bottle_1/Container
	_set_bottle_sprites(new_state,base_sprite,color_sprite)

func _set_bottle_2_states(new_state):
	bottle_2_states = new_state
	var color_sprite = $StickyNodes/Bottle_2/Color
	var base_sprite = $StickyNodes/Bottle_2/Container
	_set_bottle_sprites(new_state,base_sprite,color_sprite)

func _set_bottle_sprites(state, base_sprite, color_sprite):
	if base_sprite == null or color_sprite == null: return
	if state:
		base_sprite.texture = lifted_texture
		color_sprite.texture = lifted_color
	else:
		base_sprite.texture = grounded_texture
		color_sprite.texture = grounded_color

func _set_mouse_content(new_node_path):
	mouse_content = new_node_path
	if new_node_path == null:
		_mouse_content = null
		return
	_mouse_content = get_node(new_node_path)

func reposition_sticky_nodes():
	for n in $StickyNodes.get_children():
		for n_child in n.get_children():
			print(n_child.position,n.position)
			n_child.position = n.position

const RObserver = preload("res://scripts/test/RedstoneObserver.gd")
var robserver = RObserver.new()
var ax = Vector2(0,0)
func _mouse_sticky():
	if _mouse_content == null: return
	_mouse_content.position = $MouseObj.position
	#print(mouse_content.position,$MouseObj.position)
