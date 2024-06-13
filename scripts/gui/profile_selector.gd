extends Control

signal done()

@onready var name_input = $Panel/VBoxContainer/Control/NewName
@onready var user_item_list = $Panel/VBoxContainer/UserList
var user_array = []

func _ready():
	update_list()
	pass

func update_list():
	user_array = []
	user_array.append(User.default_user())
	user_array.append_array(Database.get_users())
	user_item_list.clear()
	for user:User in user_array:
		user_item_list.add_item(user.username)

func get_selected_user():
	var selected:Array = user_item_list.get_selected_items()
	if selected.is_empty(): return null
	
	return user_array[selected[0]]

func _on_select_pressed():
	var user:User = get_selected_user()
	if user==null: return
	Globals.user = user
	done.emit()
	queue_free()


func _on_add_pressed():
	var nuser = User.new()
	nuser.username = name_input.text
	name_input.text = ""
	Database.set_user(nuser)
	update_list()


func _on_delete_pressed():
	var user:User = get_selected_user()
	if user == null or user.id == 0: return
	Database.remove_user(user)
	update_list()
