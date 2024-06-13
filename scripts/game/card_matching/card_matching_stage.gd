extends "res://scripts/game/stage.gd"

const Card = preload("res://scripts/game/card_matching/card.gd")
const CardBranch = preload("res://branches/game/card_control.tscn")
const peek_timeout = 1

@export var texture_options: Array[TaggedResource]
@export var card_count = 16

@onready var card_row_container:VBoxContainer = $Cards
@onready var cards:Array[Card] = []
@onready var matches_required = cards.size()/2

var card_backface_texture:Texture2D
var card_backface_color:Color
var matches_found = 0
var selected_card = null
var locked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_prepare_card_collection()
	_add_card_nodes()
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func _prepare_card_collection():
	for i in range(card_count):
		var card = CardBranch.instantiate()
		card.back_color = card_backface_color
		card.back_texture = card_backface_texture
		cards.append(card)
		card.chosen.connect(_on_card_chosen)
	texture_options.shuffle()
	for i in range(int(cards.size()/2)):
		cards[i*2].resource = texture_options[i]
		cards[i*2+1].resource = texture_options[i]
	cards.shuffle()

func _add_card_nodes():
	var row = _append_row()
	var cols = recommended_columns()
	var col_count = 0
	for card_node in cards:
		if col_count >= cols:
			row = _append_row()
			col_count = 0
		row.add_child(card_node)
		col_count += 1

func _append_row():
	var row = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	card_row_container.add_child(row)
	return row

func _on_card_chosen(card:Card):
	if locked: return
	card.reveal()
	card.locked += 1
	if selected_card == null:
		selected_card = card
	else:
		var t =  Timer.new()
		var card2 = selected_card
		add_child(t)
		t.wait_time = peek_timeout
		t.timeout.connect(
			func():
				compare_cards(card,card2)
				remove_child(t)
		)
		t.start()
		selected_card = null

func compare_cards(card1:Card,card2:Card):
	if card1.face.texture != card2.face.texture:
		card1.unreveal()
		card2.unreveal()
		card1.locked -= 1
		card2.locked -= 1
		return
	
	attempt.emit(true)
	DisplayServer.tts_speak(card1.resource.tags["alt_text"],Globals.voice_id,Globals.tts_volume)
	matches_found += 2
	card1.vanish()
	card2.vanish()
	
	if matches_found == cards.size():
		win.emit("")

func _load_customization_config():
	super. _load_customization_config()
	
	card_backface_texture = Inventory.get_attribute("card_game:back_texture")\
	.parse_file(Parsers.png_path_to_texture2d)
	
	card_backface_color = Inventory.get_attribute("card_game:back_color")\
	.parse_rcontent(Parsers.json_hex_to_color)


func recommended_columns():
	#var card_sample:Card = cards[0]
	var card_dimensions = card_backface_texture.get_size()
	var root_node = self
	var vp_aspect_ratio = (root_node as Control).get_viewport_rect().size.aspect()
	var _card_count = cards.size()
	var rows = sqrt(_card_count*vp_aspect_ratio*card_dimensions.y/card_dimensions.x)
	
	return ceil(rows)

