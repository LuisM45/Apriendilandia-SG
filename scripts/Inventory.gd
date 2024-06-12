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
	var backpack_col = load("res://resources/collections/collection_backpack_items.tres") as RCollection
	for item in backpack_col.items:
		all_backpack_items[item.inner_name] = item
	

func get_user_backpack_items():
	return Database.item_name_list().map(func(x):
		return all_backpack_items.get(x)
		)

func load_customization():
	for item:BackpackItem in all_backpack_items.values():
		if !item.is_default: continue
		enable_item(item)
	
	Database.ready.connect(func():
		for item_name in Database.get_enabled_items():
			var item = all_backpack_items[item_name]
			enable_item(item)
	)
	
	#SQLcode over here should be.

func enable_item(item:BackpackItem):
	for k in item.get_keys():
		customization_config[k] = item

func enable_nsave_item(item:BackpackItem):
	for k in item.get_keys():
		Database.set_enabled_item(k,item.inner_name)
		customization_config[k] = item

func get_backpack_item(inner_name:String)->BackpackItem:
	
	return ResourceLoader.load("res://resources/backpack_items/"+inner_name+".tres","BackpackItem")
