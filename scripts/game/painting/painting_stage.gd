extends "res://scripts/game/stage.gd"

const Cauldron = preload("res://scripts/game/painting/cauldron.gd")
const Source = preload("res://scripts/game/painting/source.gd")
const PictureInfo = preload("res://scripts/game/painting/texture_info.gd")
const SourceSpriteSet = preload("res://resources/template/source_sprite_set.gd")
@onready var cauldrons = $Cauldrons.get_children() as Array[Cauldron]
@onready var potions = $Sources.get_children() as Array[Source]
@export var texture_options : Array[PictureInfo] = []

var potion_texture_set:SourceSpriteSet
var object_texture_set:Array[Texture2D]

# Called when the node enters the scene tree for the first time.
var remaining = 0

func _ready():
	super._ready()
	remaining = cauldrons.size()
	texture_options.shuffle()
	for i in range(cauldrons.size()):
		var cauld = cauldrons[i]
		cauld.texture_info = texture_options[i]
		cauld.acceptable_delta = 0.10 - difficulty * 0.01
		cauld.solved.connect(_on_solved)
	pass # Replace with function body.
	
	for p in potions:
		p.source_sprite_set = potion_texture_set
		p._ydaer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func _on_solved():
	remaining -= 1
	attempt.emit(true)
	if remaining<=0: win.emit("")

func _load_customization_config(config_dictionary:Dictionary):
	super. _load_customization_config(config_dictionary)
	potion_texture_set = (config_dictionary\
		.get("painting_potions:potion_texture_set")\
		as BackpackItem)\
		.get_rcontent()
	#object_texture_set = config_dictionary.get("painting_potions:object_texture_set")

