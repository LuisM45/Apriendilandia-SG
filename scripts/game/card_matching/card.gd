extends Control

@onready var background:TextureRect = $Background
@onready var back:TextureRect = $Background/Back
@onready var face:TextureRect = $Background/Face
var back_texture:Texture2D
var back_color:Color
var resource:TaggedResource : set = _set_resource

signal chosen(_self)
var locked = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	back.modulate = back_color
	back.texture = back_texture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_press():
	if locked > 0: return
	chosen.emit(self)
	pass # Replace with function body.

func reveal(): # When a card is chosen
	back.visible = false
	face.visible = true
	pass
	
func vanish(): # When a card is matched should disapear with oomph
	modulate = Color(0.4,0.4,0.4)
	#visible = false
	
func unreveal(): # When you f up, you f up
	back.visible = true
	face.visible = false
	
func _set_resource(new_resource):
	resource = new_resource	
	if !is_node_ready():
		ready.connect(_update_child_textures)
		return
	_update_child_textures()

func _update_child_textures():
	face.texture = resource.content
