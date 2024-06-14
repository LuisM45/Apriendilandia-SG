extends "res://scripts/game/stage.gd"

const Cauldron = preload("res://scripts/game/painting/cauldron.gd")
const Source = preload("res://scripts/game/mixin/source.gd")
const PictureInfo = preload("res://scripts/game/painting/texture_info.gd")
@onready var cauldron:Cauldron = $cauldron_1
@onready var potions = $Sources.get_children() as Array[Source]
@export var texture_options : Array[TaggedResource] = []

var potion_texture_set:SourceSpriteSet
var object_texture_set:Array[Texture2D]
var active_potions:Array[Source]

func _ready():
	super._ready()
	texture_options.shuffle()
	choose_active_potions()
	
	cauldron.current_texture = texture_options[0]
	cauldron.acceptable_delta = 0.10 - difficulty * 0.01
	cauldron.solved.connect(_on_solved)
	cauldron.failed_attempt.connect(_on_error)
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

func _on_error():
	unsuccesful_attempt.emit()

func _load_customization_config():
	super._load_customization_config()
	potion_texture_set = Inventory\
		.get_attribute("painting_potions:potion_texture_set")\
		.get_rcontent()
	#object_texture_set = config_dictionary.get("painting_potions:object_texture_set")

func choose_active_potions():
	for i in range(get_potion_count()):
		active_potions.append(potions[i])
		potions[i].visible = true

func fill_potions(cauld:Cauldron):
	var range_vector = Vector3.ONE*get_range_of_randomness()
	for pot:Source in active_potions:
		pot.current_color = ColorLib.color_rgb_random_variation(cauld.main_color(),range_vector)
		
	active_potions.pick_random().current_color = cauld.main_color()

func get_range_of_randomness():
	return 0.2 + 0.8*(10-difficulty)/9
	
func get_potion_count():
	return int(3+7*(difficulty-1)/9)
