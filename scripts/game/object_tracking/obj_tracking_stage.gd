extends "res://scripts/game/stage.gd"

const Cup = preload("res://scripts/game/object_tracking/cup.gd")
const LinearPath = preload("res://scripts/game/object_tracking/paths/linear_path.gd")
@onready var cups = $Cups.get_children() as Array[Cup]


var speed: float
var active_shuffles: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	speed = difficulty*0.1
	for cup in cups: cup.speed = speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if Input.is_action_just_pressed("object_enable"):
		_shuffle_cups()

func _shuffle_cups():
	var positions = cups.map(func (x):return x.position)
	positions.shuffle()
	active_shuffles = positions.size()
	
	for i in range(positions.size()):
		var cup = cups[i]
		var path = LinearPath.new(cup.position,positions[i])
		cup.pending_path = path
	
	
func _on_cup_finished_moving():
	active_shuffles -= 1
