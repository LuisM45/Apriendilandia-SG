extends Node

const Letter = preload("res://scripts/Letter.gd")
var wordlist = [
	"VACA",
	"OVEJA",
	"LLAMA",
	"AVESTRUZ",
	"ABEJA",
	"CERDO",
	"CAPIBARA",
	"GATO",
	"PERRO",
]


@export var word:String
@export var rounds:int

var contaminated_word:String
var letter_nodes = []

	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	wordlist.shuffle()
	deploy_round()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func win_round():
	get_node("AudioStreamPlayer").play()
	await get_tree().create_timer(1.0).timeout
	rounds -= 1
	if rounds<=0:
		get_parent().win()
	else:
		clean_round()
		deploy_round()

func deploy_round():
	word = wordlist.pop_front()
	set_contaminated_word()
	create_letter_children()

func clean_round():
	while(letter_nodes.size()>0):
		remove_child(letter_nodes.pop_back())

func set_contaminated_word():
	var random_char = randi_range(0,word.length()-1)
	var random_pos = randi_range(0,word.length())
	contaminated_word = word.substr(0,random_pos)\
		+ word[random_char]\
		+ word.substr(random_pos,word.length()-random_pos)

func letter_clicked(character_node):
	get_parent()._on_attempt()
	if(check_delete_letter(character_node)):
		remove_child(character_node)
		character_node.hide()
		get_parent()._on_correct_attempt()
		win_round()
		return
		
	get_parent()._on_failed_attempt()
	pass

func check_delete_letter(letter_node)->bool:
	var idx = letter_node.index
	var l = len(contaminated_word)
	var new_word = contaminated_word.substr(0,idx)\
		+ contaminated_word.substr(idx+1,l-idx-1)
	return new_word == word


func create_letter_children():
	for i in contaminated_word.length():
		var letter = create_letter(contaminated_word[i])
		letter.position.y = 360
		letter.position.x = 100 + 70*i


func create_letter(char:String)->Letter:
	var letter = Letter.new(char,letter_nodes.size())
	letter_nodes.append(letter)
	add_child(letter)
	return letter
