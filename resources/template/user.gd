extends Resource
class_name  User

var id: int
var username: String


static func from_dict(dict:Dictionary):
	var user = new()
	user.id = dict.get("id")
	user.username = dict.get("username")
	return user

static func default_user():
	var user = new()
	user.id = 0
	user.username = "default"
	return user 

func make_global():
	Globals.set_user(self)
