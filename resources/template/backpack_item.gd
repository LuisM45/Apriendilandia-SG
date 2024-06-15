extends Resource
class_name BackpackItem

enum TYPES {APPEARANCE=1, PHOTO=2}

@export var inner_name: String
@export var name: String
@export_file var rcontent_path: String
@export_multiline var description: String
@export var game_tags: Array
@export var type_tags: Array
@export_file("*.png") var icon_path: String
@export var is_default: bool = false
@export var types: TYPES

static func from_inner_name(_inner_name:String)->BackpackItem:
	return load("res://resources/backpack_items/"+_inner_name+".tres")

static func from_dictionary(dictionary:Dictionary)->BackpackItem:
	var item = BackpackItem.new()
	item.inner_name = dictionary.get("inner_name")
	item.name = dictionary.get("name")
	item.rcontent_path = dictionary.get("rcontent_path")
	item.description = dictionary.get("description")
	item.game_tags = dictionary.get("game_tags")
	item.type_tags = dictionary.get("type_tags")
	item.icon_path = dictionary.get("icon_path")
	item.is_default = dictionary.get("is_default")
	item.types = dictionary.get("types")
	print(dictionary.get("types"))
	print(item.types)
	return item

func is_of_game(game:String):
	return game_tags.has(game)

func is_of_type(type:String):
	return type_tags.has(type)

func get_rcontent()->Resource:
	# Intended to load Resources and extensions
	return load(rcontent_path)
	
func parse_rcontent(parser:Callable):
	# Intended to load Resources and parse it with a function
	return parser.call(get_rcontent())

func parse_file(parser:Callable):
	# Intended to load a file from its path through a parser
	return parser.call(rcontent_path)
	
func get_icon()->Texture2D:
	return load(icon_path)

func get_keys():
	var keys = []
	for type in type_tags:
			for game in game_tags:
				keys.append(game+":"+type)
	return keys

func to_dictionary()->Dictionary:
	return {
		"inner_name": inner_name,
		"name": name,
		"rcontent_path": rcontent_path,
		"description": description,
		"game_tags": game_tags,
		"type_tags": type_tags,
		"icon_path": icon_path,
		"is_default": is_default,
		"types": types,
	}

func enable():
	Inventory.enable_item(self)
