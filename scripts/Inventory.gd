extends Node

var achievements = {}
var user_data = {}
var all_backpack_items:Dictionary = {}
var customization_config = {}

func _init():
	load_backpack_items()
	load_customization()
	pass

func pull_random_item():
	var not_owned_items = all_backpack_items.keys().filter(func(x):
		return !Database.has_item(x)
	)
	if not_owned_items.is_empty(): return null
	var picked_name = not_owned_items.pick_random()
	return all_backpack_items[picked_name]

func load_backpack_items():
	const basepath = "res://resources/backpack_items/"
	var dir = DirAccess.open(basepath)
	if !(dir):
		print("resources/backpack_items does not exists")
		return
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir(): continue
		var item:BackpackItem = load(basepath+file_name)
		all_backpack_items[item.inner_name] = item
		file_name = dir.get_next()

func get_user_backpack_items():
	return Database.item_name_list().map(func(x):
		return all_backpack_items.get(x)
		)

func load_customization():
	for item:BackpackItem in all_backpack_items.values():
		if !item.is_default: continue
		enable_item(item)
		
	#SQLcode over here should be.

func enable_item(item:BackpackItem):
	for k in item.get_keys():
		customization_config[k] = item

func get_backpack_item(inner_name:String):
	return load("res://resources/backpack_items/"+inner_name+".tres")
