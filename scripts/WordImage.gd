extends Node

@export var word:String

const NamedSprite = preload("res://scripts/NamedSprite.gd")

var option_nodes = []

var en_to_es = {
	"cow": "vaca",
	"sheep": "oveja",
	"llama": "llama",
}

var options = [
	"cow",
	"sheep",
	"llama",
]

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Label").text = en_to_es[word]
	option_nodes.append_array([
		get_node("Cow"),
		get_node("Llama"),
		get_node("Sheep"),
	])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func option_pressed(chosen_node:NamedSprite):
	if chosen_node.sprite_name == word:
		for n in option_nodes:
			n.hide()
		get_parent().win()
