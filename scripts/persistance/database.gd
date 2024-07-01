extends Node

const ACHIEVEMENT_TBL = "achievement"
const INVENTORY_TBL = "inventory"
const CUSTOMIZATION_TBL = "customization"
const USER_TBL = "user"
const CONFIG_TBL = "configuration"

var metrics_db:SQLite = null

func _ready():
	metrics_db = SQLite.new()
	metrics_db.path = "metrics_db.sqlite"
	metrics_db.open_db()
	create_achievements_table()
	create_config_table()
	create_customization_table()
	create_inventory_table()
	create_metrics_table()
	create_users_table()

func set_achievement(user:User,_name:String,value:int):
	var done = metrics_db.insert_row(
		ACHIEVEMENT_TBL,
		{"name":_name,"user_id":user.id,"value":value}
	)
	if done: return true
	done = metrics_db.update_rows(
		ACHIEVEMENT_TBL,
		"name='{0}' AND user_id={1}".format([_name,user.id]),
		{"value":value}
	)
	return done

func get_achievement(user:User,_name:String):
	var row = metrics_db.select_rows(
		ACHIEVEMENT_TBL,
		"name='{0}' AND user_id={1}".format([_name,user.id]),
		["value"]
	)
	if row.is_empty(): return 0
	return row[0].get("value",0)

func get_users()->Array:
	var row = metrics_db.select_rows(
		USER_TBL,
		"",
		["id","username"]
	)
	return row.map(User.from_dict)

func get_user(id:int)->User:
	var row = metrics_db.select_rows(
		USER_TBL,
		"id={0}".format([id]),
		["id","username"]
	)
	if row.is_empty(): return null
	return User.from_dict(row[0])

func set_user(user:User):
	var data = {
			"username":user.username
		}
	if user.id != null and user.id != 0:
		data["id"]=user.id
	var done = metrics_db.insert_row(
		USER_TBL,
		data
	)
	if done: return done
	done = metrics_db.update_rows(
		USER_TBL,
		"id={0}".format([user.id]),
		{
			"username":user.username
		}
	)
	return done

func remove_user(user:User):
	return metrics_db.delete_rows(
		USER_TBL,
		"id={0}".format([user.id])
	)

func get_items(user:User,types)->Array:
	var rows = metrics_db.select_rows(
		INVENTORY_TBL,
		"user_id={0} AND (types&{1})>0".format([user.id,types]),
		["item_name"])
	return rows.map(func(x):return BackpackItem.from_inner_name(x.get("item_name")))

func append_item(user:User,backpack_item:BackpackItem):
	return metrics_db.insert_row(
		INVENTORY_TBL,
		{
			"user_id":user.id,
			"item_name":backpack_item.inner_name,
			"types":backpack_item.types,
		}
	)
	
func remove_item(user:User,backpack_item:BackpackItem):
	return metrics_db.delete_rows(
		INVENTORY_TBL,
		"user_id={0} AND item_name='{1}'".format([user.id,backpack_item.inner_name])		
	)

func get_customization_items(user:User)->Array:
	var rows = metrics_db.select_rows(
		CUSTOMIZATION_TBL,
		"user_id={0}".format([user.id]),
		["item_name"]
	)
	return rows.map(func(x):return BackpackItem.from_inner_name(x.get("item_name")))
	
func get_customization_item(user:User,attribute:String):
	var row = metrics_db.select_rows(
		CUSTOMIZATION_TBL,
		"user_id={0} AND attribute='{1}'".format([user.id,attribute]),
		["item_name"]
	)
	if row.is_empty(): return null
	return BackpackItem.from_inner_name(row[0]["item_name"])
	
func append_customization_item(user:User,item:BackpackItem):
	for attribute in item.get_keys():
		set_customization_item_for_attribute(user,item,attribute)

func set_customization_item_for_attribute(user:User,item:BackpackItem,attribute:String):
	var done = metrics_db.insert_row(
		CUSTOMIZATION_TBL,
		{
			"attribute":attribute,
			"item_name":item.inner_name,
			"user_id":user.id,
		}
	)
	if done: return done
	done = metrics_db.update_rows(
		CUSTOMIZATION_TBL,
		"attribute='{0}' AND user_id={1}".format([attribute,user.id]),
		{"item_name":item.inner_name}
	)
	return done

func set_config_value(user:User,_name:String,value:String):
	var done = metrics_db.insert_row(
		CONFIG_TBL,
		{"name":_name, "value":value, "user_id": user.id}
	)
	if done: return
	done = metrics_db.update_rows(
		CONFIG_TBL,
		"name='{0}' AND user_id={1}".format([_name,user.id]),
		{"value":value}
	)
	return done

func get_config_value(user:User,_name:String):
	var rows = metrics_db.select_rows(
		CONFIG_TBL,
		"name='{0}' AND user_id={1}".format([_name,user.id]),
		["value"]	
	)
	if rows.is_empty(): return null
	return rows[0].get("value")




func create_metrics_table():
	var metadata = {
		"id": {"data_type":"int", "primary_key": true, "not_null":true, "auto_increment": true},
		"user_id": {"data_type":"int", "not_null":true},
		"difficulty": {"data_type":"int", "not_null":true},
		"playdate": {"data_type":"int"},
		"world": {"data_type":"int", "not_null":true},
		"stage": {"data_type":"int", "not_null":true},
		"attempts": {"data_type":"int", "not_null":true},
		"corrects": {"data_type":"int", "not_null":true},
		"mistakes": {"data_type":"int", "not_null":true},
		"playtime": {"data_type":"int", "not_null":true},
		"extra": {"data_type":"string", "not_null":true},
	}
	return metrics_db.create_table("metrics", metadata)

func create_achievements_table():
	var q = "CREATE TABLE {0} (
		name STRING NOT NULL,
		user_id INTEGER NOT NULL,
		value INTEGER NOT NULL,
		PRIMARY KEY (name,user_id)
	);".format([ACHIEVEMENT_TBL])
	return metrics_db.query(q)

func create_inventory_table():
	var q = "CREATE TABLE {0} (
		item_name STRING NOT NULL,
		user_id INTEGER NOT NULL,
		types INTEGER NOT NULL,
		PRIMARY KEY (item_name,user_id)
	);".format([INVENTORY_TBL])
	return metrics_db.query(q)

func create_config_table():
	var q = " CREATE TABLE {0} (
		name STRING NOT NULL,
		value STRING,
		user_id INTEGER,
		PRIMARY KEY (name,user_id)
	);".format([CONFIG_TBL])
	return metrics_db.query(q)

func create_customization_table():
	var q = " CREATE TABLE {0} (
		user_id INTEGER NOT NULL,
		attribute STRING NOT NULL,
		item_name STRING NOT NULL,
		PRIMARY KEY (user_id,attribute)
	);".format([CUSTOMIZATION_TBL])
	return metrics_db.query(q)

func create_users_table():
	var q = "CREATE TABLE {0} (
		id INTEGER NOT NULL,
		username STRING NOT NULL,
		PRIMARY KEY (id)
	);".format([USER_TBL])
	return metrics_db.query(q)

func insert_metric(user_id,difficulty,playdate, world, stage, attempts, corrects, mistakes, playtime, extra):
	var data = {
		"user_id": user_id,
		"difficulty": difficulty,
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
	
	
