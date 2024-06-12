extends "res://scripts/game/stage.gd"

const Cauldron = preload("res://scripts/game/painting/cauldron.gd")
const Source = preload("res://scripts/game/mixin/source.gd")
const PictureInfo = preload("res://scripts/game/painting/texture_info.gd")
@onready var cauldron:Cauldron = $cauldron_1
@onready var potions = $Sources.get_children() as Array[Source]
@export var texture_options : Array[TaggedResource] = []

var potion_texture_set:SourceSpriteSet
var object_texture_set:Array[Texture2D]

func _ready():
	super._ready()
	texture_options.shuffle()
	potions.shuffle()
	
	cauldron.current_texture = texture_options[0]
	cauldron.acceptable_delta = 0.10 - difficulty * 0.01
	cauldron.solved.connect(_on_solved)
	fill_potions(cauldron)
	pass # Replace with function body.
	
	for p in potions:
		p.source_sprite_set = potion_texture_set
		p._ydaer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func _on_solved():
	attempt.emit(true)
	win.emit("")

func _load_customization_config(config_dictionary:Dictionary):
	super. _load_customization_config(config_dictionary)
	potion_texture_set = config_dictionary\
		.get("painting_potions:potion_texture_set")\
		.get_rcontent()
	#object_texture_set = config_dictionary.get("painting_potions:object_texture_set")

func fill_potions(cauld:Cauldron):
	for pot:Source in potions:
		pot.current_color = ColorLib.color_rgb_random_variation(cauld.main_color(),Vector3(0.8,0.8,0.8))
		
	potions.pick_random().current_color = cauld.main_color()
