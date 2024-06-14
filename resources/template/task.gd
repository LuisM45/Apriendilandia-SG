extends Resource
class_name Task

@export var inner_name: String
@export var name: String
@export_file("*.tscn") var guide_scene: String
@export_multiline var description: String
@export var compliments: Array[String]
@export var bad_remarks: Array[String]
@export var quick_introductions: Array[String]
@export var quick_out_remarks: Array[String]
