extends Resource
class_name BackpackItem

@export var inner_name: String
@export var name: String
@export_file var rcontent_path: String
@export_multiline var description: String
@export var game_tags: Array[String]
@export var type_tags: Array[String]
@export_file("*.png") var icon_path: String
@export var is_default: bool = false

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
	var img = Image.load_from_file(icon_path)
	return ImageTexture.create_from_image(img)

func get_keys():
	var keys = []
	for type in type_tags:
			for game in game_tags:
				keys.append(game+":"+type)
	return keys

func enable():
	Inventory.enable_item(self)
