extends "res://scripts/game/stage.gd"

const Card = preload("res://scripts/game/card_matching/card.gd")
const TaggedResource = preload("res://resources/template/tagged_resource.gd")
const peek_timeout = 1

@export var texture_options: Array[TaggedResource]

@onready var cards = $Cards.get_children() as Array[Card]
@onready var matches_required = cards.size()/2

var matches_found = 0
var selected_card = null
var locked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	texture_options.shuffle()
	cards.shuffle()
	for card in cards: card.chosen.connect(_on_card_chosen)
	for i in range(cards.size()/2):
		cards[i*2].resource = texture_options[i]
		cards[i*2+1].resource = texture_options[i]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

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
	matches_found += 2
	card1.vanish()
	card2.vanish()
	
	print(matches_found)
	if matches_found == cards.size():
		print("won")
		win.emit("")

func _load_customization_config(config_dictionary:Dictionary):
	super. _load_customization_config(config_dictionary)
	var card_background_texture = config_dictionary.get("card_game:card_background_texture")
	var card_backface_texture = config_dictionary.get("card_game:card_backface_texture")
	var card_face_texture_set = config_dictionary.get("card_game:card_face_texture_set")
	
