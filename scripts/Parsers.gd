extends Node

func json_array_to_color(j:JSON):
	return array_to_color(j.data)

func json_hex_to_color(j:JSON):
	return Color.html(j.data)

func array_to_color(a:Array):
	return Color(a[0],a[1],a[2],a[3])

func png_path_to_texture2d(s):
	return ResourceLoader.load(s,"ImageTexture")

func gender_to_lang_items(is_male:bool,key_prefix:=""):
	if is_male:
		return {
			key_prefix+"singular_pronoun":"el",
			key_prefix+"plural_pronoun":"los",
			key_prefix+"word_modifier":"o",
		}
	else:
		return {
			key_prefix+"singular_pronoun":"la",
			key_prefix+"plural_pronoun":"las",
			key_prefix+"word_modifier":"a"
		}
	
