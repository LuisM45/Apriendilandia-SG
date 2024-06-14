extends Control
const ItemInfoPanel = preload("res://scripts/gui/ItemInfoPanel.gd")


@onready var item_list:ItemList = $LPanel/ItemList
@onready var item_info_panel:ItemInfoPanel = $ItemInfoPanel
@onready var exit_button: BaseButton = $LPanel/ExitButton
var backpack_items

func _ready():	
	backpack_items = Inventory.get_backpack_items()
	item_list.item_activated.connect(_on_item_selected)
	item_list.item_selected.connect(_on_item_selected)
	exit_button.pressed.connect(exit)
	for i:BackpackItem in backpack_items:
		item_list.add_item(i.name)

func _on_item_selected(item_idx:int):
	var item = backpack_items[item_idx]
	item_info_panel.set_item(item)

func exit():
	queue_free()
