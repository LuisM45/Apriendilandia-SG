extends "res://scripts/game/stage.gd"

const Cauldron = preload("res://scripts/game/mixin/cauldron.gd")
const Source = preload("res://scripts/game/mixin/source.gd")
@onready var cauldrons = $Cauldrons.get_children() as Array[Cauldron]
@onready var potions = $Sources.get_children() as Array[Source]
var potion_sprite_set: SourceSpriteSet

# Called when the node enters the scene tree for the first time.
var remaining = 0
func _ready():
	super._ready()
	remaining = cauldrons.size()
	for cauld in cauldrons:
		cauld.acceptable_delta = 0.10 - difficulty * 0.01
		cauld.solved.connect(_on_solved)
	
	for p in potions:
		p.source_sprite_set = potion_sprite_set
		p._ydaer()

func _process(delta):
	super._process(delta)
	pass

func _on_solved():
	remaining -= 1
	attempt.emit(true)
	if remaining<=0: win.emit("")

func _load_customization_config(config_dictionary:Dictionary):
	super. _load_customization_config(config_dictionary)
	potion_sprite_set = config_dictionary\
		.get("potion_mixing:potion_texture_set")\
		.get_rcontent()
		
	#var cauldron_sprite_set = config_dictionary.get("potion_mixing:potion_sprite_set")
