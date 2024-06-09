extends "res://scripts/game/stage.gd"

const Cauldron = preload("res://scripts/game/mixin/cauldron.gd")
const Source = preload("res://scripts/game/mixin/source.gd")
var COLOR_OPTIONS = [
	Color(1.000,0.929,0.000),
	Color(1.000,0.000,0.000),
	Color(1.000,0.000,0.671),
	Color(0.000,0.278,0.671),
	Color(0.000,0.929,1.000),
	Color(0.000,0.710,0.000),
	Color(1.000,1.000,1.000),
	Color(0.000,0.000,0.000),
]


@onready var cauldrons = $Cauldrons.get_children() as Array[Cauldron]
@onready var potions = $Sources.get_children() as Array[Source]
var potion_sprite_set: SourceSpriteSet
var colors_in_stock = []

# Called when the node enters the scene tree for the first time.
var remaining = 0
func _ready():
	super._ready()
	COLOR_OPTIONS.shuffle()
	remaining = cauldrons.size()
	
	for pc in range(_bottles_count()):
		colors_in_stock.append(COLOR_OPTIONS[pc])
		potions[pc].current_color = COLOR_OPTIONS[pc]
		potions[pc].visible = true
		
	for p in potions:
		p.source_sprite_set = potion_sprite_set
		p._ydaer()

	for cauld in cauldrons:
		cauld.acceptable_delta = 0.10 - difficulty * 0.01
		cauld.target_color = _get_sample_color()
		cauld.solved.connect(_on_solved)
		
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

func _bottles_count():
	# A function based on difficulty
	return 6
	pass

func _combinations_count():
	return 2
	# A function based on difficulty
	pass

func _get_sample_color():
	var chosen_colors:Array[Color] = []
	for i in range(_combinations_count()):
		chosen_colors.append(colors_in_stock.pick_random())
	return ColorLib.combine_colors_no_weights(chosen_colors)
	
