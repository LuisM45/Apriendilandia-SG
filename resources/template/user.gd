extends Resource
class_name  User

var id: int
var username: String
var avatar_name: String


static func from_dict(dict:Dictionary):
	var user = new()
	user.id = dict.get("id")
	user.username = dict.get("username")
	user.avatar_name = dict.get("avatar_name")
	return user

static func default_user():
	var user = new()
	user.id = 0
	user.username = "default"
	return user 

func get_avatar()->Texture2D:
	if avatar_name == null: return
	return Inventory.all_backpack_items[avatar_name].get_rcontent()

func make_global():
	Globals.user = self
