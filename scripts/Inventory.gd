extends Node
const UnlockScreen = preload("res://branches/gui/unlock_screen.tscn")
const PhotoScreen = preload("res://branches/journal/detail_photo.tscn")

var achievements = {}
var user_data = {}
var all_backpack_items:Dictionary = {}
var customization_config = {}

func _init():
	if ! Database.is_node_ready(): await Database.ready
	if ! Globals.is_node_ready(): await Globals.ready
	load_backpack_items()
	load_customization()
	Globals.user_changed.connect(load_customization)
	pass

func pull_random_item():
	var owned_items = Database.get_items(Globals.user,BackpackItem.TYPES.APPEARANCE).map(func(x):return x.inner_name)
	var all_items = all_backpack_items.values()\
		.filter(func(x):return x.types&BackpackItem.TYPES.APPEARANCE>0)\
		.map(func(x): return x.inner_name)
	var not_owned_items = all_items.filter(func(x):return x not in owned_items)
	if not_owned_items.is_empty(): return null
	
	var picked_name = not_owned_items.pick_random()
	return all_backpack_items[picked_name]

func pull_random_photo(photo_type:String):
	var owned_items = Database.get_items(Globals.user,BackpackItem.TYPES.PHOTO).map(func(x):return x.inner_name)
	var all_items = all_backpack_items.values()\
		.filter(func(x:BackpackItem):return x.types==BackpackItem.TYPES.PHOTO)\
		.filter(func(x:BackpackItem):return photo_type in x.type_tags)\
		.map(func(x): return x.inner_name)
	var not_owned_items = all_items.filter(func(x):return x not in owned_items)
	if not_owned_items.is_empty(): return null
	
	var picked_name = not_owned_items.pick_random()
	return all_backpack_items[picked_name]

func load_backpack_items():
	var backpack_col = load("res://resources/collections/collection_backpack_items.tres") as RCollection
	for item in backpack_col.items:
		all_backpack_items[item.inner_name] = item

func get_attribute(attribute_name:String)->BackpackItem:
	return customization_config.get(attribute_name)

func unlock_item(item:BackpackItem):
	Database.append_item(Globals.user,item)

func get_backpack_items():
	return Database.get_items(Globals.user,BackpackItem.TYPES.APPEARANCE)

func get_backpack_photos():
	return Database.get_items(Globals.user,BackpackItem.TYPES.PHOTO)

func try_show_unlock_item():
	var item = pull_random_item()
	if item == null: return null
	unlock_item(item)
	var unlock_screen = UnlockScreen.instantiate()
	unlock_screen.backpack_item = item
	get_tree().root.add_child(unlock_screen)
	return unlock_screen

func try_show_unlock_photo(photo_type:String):
	var photo = pull_random_photo(photo_type)
	if photo == null: return null
	unlock_item(photo)
	var photo_screen = PhotoScreen.instantiate()
	photo_screen.photo = photo
	get_tree().root.add_child(photo_screen)
	return photo_screen

func load_customization():
	customization_config = {}
	for item:BackpackItem in all_backpack_items.values():
		if !item.is_default: continue
		_enable_item_no_db(item)
	
	for item in Database.get_customization_items(Globals.user):
		_enable_item_no_db(item)

func enable_item(item:BackpackItem):
	Database.append_customization_item(Globals.user,item)
	_enable_item_no_db(item)

func _enable_item_no_db(item:BackpackItem):
	for k in item.get_keys():
		customization_config[k] = item
