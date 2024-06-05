extends Resource
class_name Task

@export var inner_name: String # for script and db references
@export var name: String # when read outlout
@export_multiline var description: String # resume of what needs to be done. To be read out loud. Mandatory
@export_multiline var introduction: Array[String] # detailed of steps. To be read out loud. split by crlf. Use case still pending
@export_multiline var instructions: String # detailed of steps. To be read out loud. split by crlf. Use case still pending
@export_multiline var outroduction: Array[String] # detailed of steps. To be read out loud. split by crlf. Use case still pending
@export_file("*.tscn") var guide_scene: String # to be played in a stage as an overlay
