# I am well aware utils funcions are smell. However. I have to put some code
# here to workaround some shenanigans that Godot introduces
extends Node
	
func export_backpack_items():
	var backpackCol = RCollection.new()
	const basepath = "res://resources/backpack_items/"
	var dir = DirAccess.open(basepath)
	if !(dir):
		return
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			file_name = dir.get_next()
			continue
			
		var item:BackpackItem = load(basepath+file_name)
		backpackCol.items.append(item)
		file_name = dir.get_next()
	
	ResourceSaver.save(
		backpackCol,
		"res://resources/collections/collection_backpack_items.tres"
	)

func backpack_dir_dump_to_rcol():
	var backpackCol = RCollection.new()
	const basepath = "res://resources/backpack_items/"
	var dir = DirAccess.open(basepath)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var item:BackpackItem = load(basepath+file_name)
		backpackCol.items.append(item)
		file_name = dir.get_next()
	
	ResourceSaver.save(
		backpackCol,
		"res://resources/collections/collection_backpack_items.tres"
	)

func backpack_dir_dump_to_json():
	var basepath = "res://resources/backpack_items/"
	var dir = DirAccess.open(basepath)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var items = []
	while file_name != "":
		if dir.current_is_dir():
			file_name = dir.get_next()
			continue
		var item = load(basepath+file_name) as BackpackItem
		item.inner_name = file_name.reverse().substr(5).reverse()
		items.append(item.to_dictionary())
		file_name = dir.get_next()
	
	var dump_file = FileAccess.open("res://resources/backpack_items.json",FileAccess.WRITE)
	dump_file.store_line(JSON.stringify(items,"    "))
	dump_file.close()
		
func backpack_json_dump_to_dir():
	var dump_file = FileAccess.open("res://resources/backpack_items.json",FileAccess.READ)
	var items = JSON.parse_string(dump_file.get_as_text())
	for item in items:
		var backpack_item = BackpackItem.from_dictionary(item)
		
		ResourceSaver.save(
			backpack_item,
			"res://resources/backpack_items/"+backpack_item.inner_name+".tres")
