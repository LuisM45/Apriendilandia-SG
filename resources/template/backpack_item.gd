extends Resource
class_name BackpackItem

@export var inner_name: String
@export var name: String
@export var description: String
@export var resource: Resource
@export var type_tags: Array[String]
@export var icon: Texture2D

func is_type(type:String):
	return type_tags.has(type)
