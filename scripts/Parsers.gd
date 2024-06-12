extends Node

func json_array_to_color(j:JSON):
	return array_to_color(j.data)

func json_hex_to_color(j:JSON):
	return Color.html(j.data)

func array_to_color(a:Array):
	return Color(a[0],a[1],a[2],a[3])

func png_path_to_texture2d(s):
	return ResourceLoader.load(s,"ImageTexture")
