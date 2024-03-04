extends Node

const Character = preload("res://scripts/Character.gd")

@export var word:String
@export var contaminated_word:String

var children_characters = []

func get_contaminant():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	define_children()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func letter_clicked(character_node):
	if(check_delete_letter(character_node)):
		remove_child(character_node)
		character_node.hide()
		get_parent().win()
	pass

func check_delete_letter(character_node)->bool:
	var idx =  children_characters.find(character_node)
	var l = len(contaminated_word)

	var new_word = contaminated_word.substr(0,idx)\
		+ contaminated_word.substr(idx+1,l-idx-1)

	return new_word == word

func define_children():
	# TODO: Automated creation of child/images
	children_characters.append_array([
		get_node("CharM"),
		get_node("CharO1"),
		get_node("MistakeChar"),
		get_node("CharN"),
		get_node("CharO2"),
	])
	pass	
