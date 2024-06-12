# I am well aware utils funcions are smell. However. I have to put some code
# here to workaround some shenanigans that Godot introduces
extends Node
	
func export_backpack_items():
	print("export_backpack_items()")
	var backpackCol = RCollection.new()
	const basepath = "res://resources/backpack_items/"
	var dir = DirAccess.open(basepath)
	if !(dir):
		print("resources/backpack_items does not exists")
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
