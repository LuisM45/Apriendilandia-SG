extends "res://scripts/game/stage.gd"
const SpritePair = preload("res://scripts/game/match_shadow/sprite_pair.gd")
@onready var pairs = ($MatchPairs.get_children()) as Array[SpritePair]
@export var possible_backgrounds: Array[Texture2D]
@export var possible_objects: Array[TaggedResource]
@export var config_context: String = "match_game"

var remaining = 0
func _ready():
	super._ready()
	var minimal_count = min(pairs.size(), possible_objects.size())
	var overflow_count = pairs.size()-minimal_count
	
	possible_objects.shuffle()
	remaining = minimal_count
	for pair in pairs:
		pair.correct_match.connect(func x(_b):attempt.emit(true))
		pair.incorrect_match.connect(func x(_b):attempt.emit(false))
	
	var positions = []
	for i in range(minimal_count):
		positions.append(pairs[i].shadow_body.position)
	positions.shuffle()
	
	for i in range(minimal_count):
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

func _load_customization_config():
	super. _load_customization_config()
	var _objects_texture_set = Inventory.get_attribute(config_context+":objects_texture_set")
