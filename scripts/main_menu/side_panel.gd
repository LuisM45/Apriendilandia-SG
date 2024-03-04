extends CanvasLayer

var medals = []
const Stage = preload("res://scripts/stage.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	medals = [
		get_node("MedalBeach"),
		get_node("MedalForest"),
		get_node("MedalCity"),
	]
	var achievements = Stage.completed_acts
	for i in medals.size():
		if achievements[i]: medals[i].show()
	if achievements.all(func(a): return a):
		get_node("MedalAll").show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
