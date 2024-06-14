extends "res://scripts/game/stage.gd"
const SpritePair = preload("res://scripts/game/match_shadow/sprite_pair.gd")
@onready var pairs = ($MatchPairs.get_children()) as Array[SpritePair]
@export var possible_backgrounds: Array[Texture2D]
@export var possible_objects: Array[TaggedResource]
@export var config_context: String = "match_game"

var enabled_pairs: Array[SpritePair] = []
var remaining
func _ready():
	super._ready()
	remaining = get_enabled_pairs_count()
	possible_objects.shuffle()
	
	for i in range(get_enabled_pairs_count()):
		enabled_pairs.append(pairs[i])
	for pair in enabled_pairs:
		pair.visible = true
		pair.correct_match.connect(func x(_b):attempt.emit(true))
		pair.incorrect_match.connect(func x(_b):attempt.emit(false))
	
	var positions = []
	for pair in enabled_pairs:
		positions.append(pair.shadow_body.position)
	positions.shuffle()
	
	for i in range(enabled_pairs.size()):
		enabled_pairs[i].base_sprite = possible_objects[i]
		enabled_pairs[i].shadow_body.position = positions[i]
		
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

func get_enabled_pairs_count():
	if difficulty<=2: return 2
	if difficulty<=3: return 3
	if difficulty<=5: return 4
	if difficulty<=7: return 5
	return 6
