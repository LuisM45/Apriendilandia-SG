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
	$AnimatedSprite2D.play()
	
	for pc in range(_bottles_count()):
		colors_in_stock.append(COLOR_OPTIONS[pc])
		potions[pc].current_color = colors_in_stock[pc]
		potions[pc].visible = true
		
	for p in potions:
		p.source_sprite_set = potion_sprite_set
		p._ydaer()

	for cauld in cauldrons:
		cauld.acceptable_delta = 0.10 - difficulty * 0.01
		cauld.max_weight = _combinations_count()
		cauld.target_color = _get_sample_color()
		cauld.solved.connect(_on_solved)
		cauld.got_reset.connect(_on_error)
		
func _process(delta):
	super._process(delta)
	
func _on_solved():
	remaining -= 1
	attempt.emit(true)
	if remaining<=0: win.emit("")

func _on_error():
	unsuccesful_attempt.emit()

func _load_customization_config():
	super. _load_customization_config()
	potion_sprite_set = Inventory\
		.get_attribute("potion_mixing:potion_texture_set")\
		.get_rcontent()
		
	#var cauldron_sprite_set = config_dictionary.get("potion_mixing:potion_sprite_set")

func _bottles_count():
	if difficulty <= 3: return 3
	if difficulty <= 4: return 4
	if difficulty <= 5: return 6
	if difficulty <= 7: return 4
	if difficulty <= 8: return 5
	return 6

func _combinations_count():
	if difficulty<=5: return 2
	return 3

func _get_sample_color():
	var chosen_colors:Array[Color] = []
	for i in range(_combinations_count()):
		chosen_colors.append(colors_in_stock.pick_random())
	return ColorLib.combine_colors_no_weights(chosen_colors)
	
