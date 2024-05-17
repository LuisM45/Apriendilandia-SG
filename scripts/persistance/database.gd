extends Node


var player_db = null
var metrics_db = null

# Called when the node enters the scene tree for the first time.
func _ready():
	metrics_db = SQLite.new()
	metrics_db.path = "metrics_db.sqlite"
	metrics_db.open_db()
	create_metrics_table()
	create_achievements_table()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_metrics_table():
	var metadata = {
		"id": {"data_type":"int", "primary_key": true, "not_null":true, "auto_increment": true},
		"playdate": {"data_type":"int"},
		"world": {"data_type":"int", "not_null":true},
		"stage": {"data_type":"int", "not_null":true},
		"attempts": {"data_type":"int", "not_null":true},
		"corrects": {"data_type":"int", "not_null":true},
		"mistakes": {"data_type":"int", "not_null":true},
		"playtime": {"data_type":"int", "not_null":true},
		"extra": {"data_type":"string", "not_null":true},
	}
	metrics_db.create_table("metrics", metadata)

func create_achievements_table():
	var metadata = {
		"name": {"data_type":"string", "primary_key": true, "not_null":true},
		"value": {"data_type":"int", "not_null":true},
	}
	metrics_db.create_table("achievements", metadata)

func insert_metric(playdate, world, stage, attempts, corrects, mistakes, playtime, extra):
	var data = {
		"playdate": playdate,
		"world": world,
		"stage": stage,
		"attempts": attempts,
		"corrects": corrects,
		"mistakes": mistakes,
		"playtime": playtime,
		"extra": extra,
	}
	metrics_db.insert_row("metrics", data)
	
	
