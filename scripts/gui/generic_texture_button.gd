extends BaseButton
const ButtonComposite = preload("res://scripts/gui/button_composite.gd")


func _ready():
	ButtonComposite.apply(self)
