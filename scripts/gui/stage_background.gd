extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	_load_customization_config(Globals.customization_config)
	size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _load_customization_config(config_dictionary:Dictionary):
	$ColorRect.color = config_dictionary\
		.get("background:accent_color")\
		.parse_rcontent(Parsers.json_hex_to_color)
		
	$TextureRect.modulate = config_dictionary\
		.get("background:background_color")\
		.parse_rcontent(Parsers.json_hex_to_color)
		
	$TextureRect.texture = config_dictionary\
		.get("background:texture")\
		.parse_file(Parsers.png_path_to_texture2d)
		
