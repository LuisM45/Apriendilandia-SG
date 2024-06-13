extends "res://scripts/game/stage.gd"

const Cup = preload("res://scripts/game/object_tracking/cup.gd")
const Die = preload("res://scripts/game/object_tracking/die.gd")
const path = preload("res://scripts/game/object_tracking/paths/export.gd")
@onready var cups = $Cups.get_children() as Array[Cup]
var hiding_cup:Cup = null
@onready var die = $Die


var speed: float
var active_shuffles: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	speed = difficulty*0.1
	for cup in cups:
		cup.speed = speed
		cup.on_click.connect(_on_cup_chosen)
	pass # Replace with function body.
	
	
	hiding_cup = cups.pick_random()
	hiding_cup.content = die
	die.position = hiding_cup.position
	_hide_die(hiding_cup).edge_reached
		#.connect(func(a):_shuffle_cups())

func _process(delta):
	super._process(delta)
		
func _shuffle_cups(times=5):
	for a in range(times):
		_shuffle_cups_once()
	

func _shuffle_cups_once():
	var positions = cups.map(func (x):return x.expected_last_pos())
	positions.shuffle()
	active_shuffles = positions.size()
	
	for i in range(positions.size()):
		var cup = cups[i]
		var path = path.LinearPath.new(cup.expected_last_pos(),positions[i])
		cup.append_path(path)
	
	
func _hide_die(cup:Cup):
	var cup_target_pos = die.position
	cup.append_path(path.LinearPath.new(cup.position,cup_target_pos))
	_lift_n_lower_cup(cup,100)
	cup.append_path(path.LinearPath.new(cup_target_pos,cup.position))
	return cup.path_queue[-1]

func _lift_n_lower_cup(cup:Cup,height):
	cup.position += Vector2(-1,0)
	var path = path.ParabolaOnX.new(cup.expected_last_pos(),cup.expected_last_pos()+Vector2(1,0),height)
	path.edge_reached.connect(func (a): die.visible = false)
	cup.append_path(path)
	return cup.path_queue[-1]

func _on_cup_finished_moving():
	active_shuffles -= 1

func _show_cup_content(cup:Cup):
	cup.lift()
	cup.append_path(path.NoPath.new(cup.expected_last_pos(),0.7))
	cup.lower()

func _on_cup_chosen(cup:Cup):
	_show_cup_content(cup)
	if cup == hiding_cup:
		attempt.emit(true)
		win.emit()
		
	else:
		attempt.emit(false)
		
func _load_customization_config():
	super. _load_customization_config()
	var cup_texture = Inventory.get_attribute("cup_texture")
	var die_texture = Inventory.get_attribute("die_texture")
