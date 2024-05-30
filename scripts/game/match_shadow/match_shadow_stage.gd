extends "res://scripts/game/stage.gd"
const SpritePair = preload("res://scripts/game/match_shadow/sprite_pair.gd")
const TaggedResource = preload("res://resources/template/tagged_resource.gd")
@onready var pairs = ($MatchPairs.get_children()) as Array[SpritePair]
@onready var background_sprite:TextureRect = $Background
@export var possible_backgrounds: Array[Texture2D]
@export var possible_objects: Array[TaggedResource]

var remaining = 0
func _ready():
	super._ready()
	var minimal_count = min(pairs.size(), possible_objects.size())
	var overflow_count = pairs.size()-minimal_count
	background_sprite.texture = possible_backgrounds.pick_random()
	
	possible_objects.shuffle()
	remaining = minimal_count
	for pair in pairs:
		pair.correct_match.connect(func x(b):attempt.emit(true))
		pair.incorrect_match.connect(func x(b):attempt.emit(false))
		
	
	var positions = []
	for i in range(minimal_count):
		positions.append(pairs[i].shadow_body.position)
	positions.shuffle()
	
	for i in range(minimal_count):
		var scale = possible_objects[i].content.get_size()
		pairs[i].base_sprite = possible_objects[i]
		pairs[i].shadow_body.position = positions[i]
		
	for i in range(overflow_count):
		pairs[i].base_sprite = null
	pass # Replace with function body.

func resize_background():
	#background_sprite.position = get_viewport_rect().size
	pass

func _on_correct_attempt():
	super._on_correct_attempt()
	remaining-=1
	if remaining <= 0:
		win.emit("")
	
func _on_failed_attempt():
	super._on_failed_attempt()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)


func _on_original_body_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
