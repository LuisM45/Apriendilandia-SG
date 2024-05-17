extends Node

var rounds: int = 3
var word:String
var option_nodes = []
static var sprite_template = preload("res://branches/beach/animal_sprite.tscn")
const NamedSprite = preload("res://scripts/NamedSprite.gd")

var en_to_es = {
	"cow": "vaca",
	"sheep": "oveja",
	"llama": "llama",
	"ostrich": "avestruz",
	"bee": "abeja", # be me? me bee
	"pig": "cerdo",
	"capybara": "capibara",
	"cat": "gato",
	"dog": "perro"
}
var options_bank = [
	"cow",
	"sheep",
	"llama",
	"ostrich",
	"bee", # be me? me bee
	"pig",
	"capybara",
	"cat",
	"dog"
]



# Called when the node enters the scene tree for the first time.
func _ready():
	deploy_round()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deploy_round

func win_round():
	get_node("AudioStreamPlayer").play()
	await get_tree().create_timer(1.0).timeout
	rounds -= 1
	if rounds<=0:
		get_parent().win()
	else:
		clean_round()
		deploy_round()

func clean_round():
	while option_nodes.size()>0:
		remove_child(option_nodes.pop_front())

func deploy_round():
	var options = random_options()
	word = options[0]
	get_node("Label").text = en_to_es[word]
	options.shuffle()
	
	for i in options.size():
		deploy_sprite(options[i],900,125+200*i)
		
	
func deploy_sprite(word:String,x:int,y:int):
	var new_sprite = sprite_template.instantiate()
	new_sprite.set_sprite_name(word)
	option_nodes.push_back(new_sprite)
	add_child(new_sprite)
	new_sprite.position.x = x
	new_sprite.position.y = y
	pass	

func random_options():
	var o1 = options_bank.pop_at(randi_range(0,options_bank.size()-1))
	var o2 = options_bank.pop_at(randi_range(0,options_bank.size()-1))
	var o3 = options_bank.pop_at(randi_range(0,options_bank.size()-1))
	options_bank.append_array([o1,o2,o3])
	return [o1,o2,o3]


func option_pressed(chosen_node:NamedSprite):
	if chosen_node.sprite_name == word:
		for n in option_nodes:
			n.hide()
		win_round()

