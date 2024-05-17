extends "res://scripts/game/stage.gd"
const SpritePair = preload("res://scripts/game/match_shadow/sprite_pair.gd")
@onready var pairs = ($MatchPairs.get_children()) as Array[SpritePair]
@export var images: Array[Texture2D]


var remaining = 0
func _ready():
	super._ready()
	var minimal_count = min(pairs.size(), images.size())
	var overflow_count = pairs.size()-minimal_count
	
	images.shuffle()
	remaining = minimal_count
	for pair in pairs:
		pair.correct_match.connect(func x(b):_on_correct_attempt())
		pair.incorrect_match.connect(func x(b):_on_failed_attempt())
		
	
	var positions =[]
	for i in range(minimal_count):
		positions.append(pairs[i].shadow_body.position)
	positions.shuffle()
	
	for i in range(minimal_count):
		var scale = images[i].get_size()
		pairs[i].base_sprite = images[i]
		pairs[i].shadow_body.position = positions[i]
		
	for i in range(overflow_count):
		pairs[i].base_sprite = null
	pass # Replace with function body.

func _on_correct_attempt():
	super._on_correct_attempt()
	remaining-=1
	if remaining <= 0:
		super.win()
	
func _on_failed_attempt():
	super._on_failed_attempt()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._ready()



func _on_original_body_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
