extends CharacterBody2D

@onready var background:TextureRect = $Background
@onready var back:TextureRect = $Back
@onready var face:TextureRect = $Face
var resource : set = _set_resource

signal chosen(_self)
var locked = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(_on_input_event)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_select():
	pass


func _on_input_event(viewport, event, shape_idx):
	if locked > 0: return
	if event is InputEventMouseButton and event.is_pressed():
		chosen.emit(self)
	pass # Replace with function body.

func reveal(): # When a card is chosen
	scale *= Vector2(1.2,1.2)
	back.visible = false
	face.visible = true
	pass
	
func vanish(): # When a card is matched should disapear with oomph
	visible = false
	
func unreveal(): # When you f up, you f up
	scale /= Vector2(1.2,1.2)
	back.visible = true
	face.visible = false
	
func _set_resource(new_resource):
	resource = new_resource
	face.texture = new_resource.content
