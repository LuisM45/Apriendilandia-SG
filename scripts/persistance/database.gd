extends Node

const ACHIEVEMENT_TBL = "achievement"
const INVENTORY_TBL = "inventory"
const CUSTOMIZATION_TBL = "customization"

var metrics_db:SQLite = null

func set_achievement(value:int,_name:String,username:="default"):
	if get_achievement(_name,username) == null:
		return _insert_achievement(value,_name,username)
	else:
		return _update_achievement(value,_name,username)

func get_achievement(_name:String,username:="default"):
	var row = _select_achievement(_name,username)
	if row.is_empty(): return null
	return row[0].get("value")

func give_item(item_name:String,username:="default"):
	if has_item(item_name,username): return false
	return metrics_db.insert_row(
		INVENTORY_TBL,
		{
			"username":username,
			"item_name":item_name
		}
	)
	
func remove_item(item_name:String,username:="default"):
	return metrics_db.delete_rows(
		INVENTORY_TBL,
		"username='{0}' AND item_name='{1}'".format([username,item_name])		
	)
	
func has_item(item_name:String,username:="default"):
	return !metrics_db.select_rows(
		INVENTORY_TBL,
		"username='{0}' AND item_name='{item_name}'".format([username,item_name]),
		["item_name"])\
		.is_empty()
	
func item_name_list(username:="default")->Array:
	var rows = metrics_db.select_rows(
		INVENTORY_TBL,
		"username='{0}'".format([username]),
		["item_name"])
	return rows.map(func(x):return x.get("item_name"))
	
func get_enabled_items(username:="default"):
	var rows = metrics_db.select_rows(
		CUSTOMIZATION_TBL,
		"username='{0}'".format([username]),
		["item_name"]
		)
	return rows.map(func(x):return x.get("item_name"))

func set_enabled_item(attribute:String,item_name:String,username:="default"):
	var done = metrics_db.insert_row(
		CUSTOMIZATION_TBL,
		{
			"attribute":attribute,
			"item_name":item_name,
			"username":username,
		}
	)
	if done: return done
	done = metrics_db.update_rows(
		CUSTOMIZATION_TBL,
		"attribute='{0}' AND item_name='{1}'".format([attribute,item_name]),
		{"item_name":item_name}
	)
	return done
	
func _select_achievement(_name:String,username:="default"):
	return metrics_db.select_rows(
		ACHIEVEMENT_TBL,
		"_name='{0}' AND username='{1}'".format([_name,username]),
		["value"]
	)

func _insert_achievement(value:int,_name:String,username:="default"):
	return metrics_db.insert_row(
		ACHIEVEMENT_TBL,{
			"name":_name,
			"username":username,
			"value":value,
		}
	)

func _update_achievement(value:int,_name:String,username:="default"):
	return metrics_db.update_rows(
		ACHIEVEMENT_TBL,
		"name='{0}' AND username='{1}'".format([_name,username]),
		{"value":value}
	)

func _ready():
	metrics_db = SQLite.new()
	metrics_db.path = "metrics_db.sqlite"
	metrics_db.open_db()
	create_metrics_table()
	create_achievements_table()
	create_customization_table()
	create_inventory_table()

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
	var q = " CREATE TABLE {0} (
		name STRING NOT NULL,
		username STRING NOT NULL,
		value INTEGER NOT NULL,
		PRIMARY KEY (_name,username)
	);".format([ACHIEVEMENT_TBL])
	return metrics_db.query(q)

func create_inventory_table():
	var q = " CREATE TABLE {0} (
		item_name STRING NOT NULL,
		username STRING NOT NULL,
		PRIMARY KEY (item_name,username)
	);".format([INVENTORY_TBL])
	return metrics_db.query(q)

func create_customization_table():
	var q = " CREATE TABLE {0} (
		username STRING NOT NULL,
		attribute STRING NOT NULL,
		item_name STRING NOT NULL,
		PRIMARY KEY (attribute,username)
	);".format([CUSTOMIZATION_TBL])
	return metrics_db.query(q)

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
	
	
