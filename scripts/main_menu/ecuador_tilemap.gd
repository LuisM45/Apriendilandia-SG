extends TileMap
const Paths = preload("res://scripts/game/object_tracking/paths/export.gd")


signal layer_clicked(layer_id)
signal layer_entered(layer_id)
signal layer_exited(layer_id)

var last_layer_hovered = -1
var hover_delta = 0.0
var blink_delta = 0.0

var layer_disabled = {}
var layer_blink = {}

func _ready():
	layer_exited.connect(_on_layer_exit)
	pass

func _process(delta):
	blink_delta+=delta
	hover_delta+=delta
	blink()

func blink():
	blink_other()
	blink_hover()

func disable_layer(layer):
	layer_disabled[layer] = true
	set_layer_modulate(layer,Color.DIM_GRAY)
	
func enable_layer(layer):
	layer_disabled.erase(layer)

func blink_hover():
	var layer = last_layer_hovered
	if(layer<=0): return
	if(layer_disabled.has(layer)): return
	var color = ColorLib.lerp(Color(0.8,0.8,0.8),Color(0.9,1.1,1.1),cos(hover_delta*PI/2)**2)
	set_layer_modulate(layer,color)

func blink_other():
	for layer in layer_blink.keys():
		var color = ColorLib.lerp(Color(0.7,0.7,0.7),Color(1.2,1.2,0.7),cos(hover_delta*PI/2)**2)
		set_layer_modulate(layer,color)

func _on_layer_exit(layer):
	if(layer<=0): return
	if(layer_disabled.has(layer)): return
	set_layer_modulate(layer,Color.WHITE)


func _on_click():
	var layer = get_mouse_layer()
	if layer >= 0 and !layer_disabled.has(layer):
		layer_clicked.emit(layer)
	

func _on_hover():
	var layer = get_mouse_layer()
	if last_layer_hovered != layer:
		layer_entered.emit(layer)
		layer_exited.emit(last_layer_hovered)
		last_layer_hovered = layer
		hover_delta = PI/4*3
			
func get_mouse_layer():
	var mouse_coords = get_viewport().get_mouse_position()
	var local_coords = to_local(mouse_coords)
	var tilemap_coords = local_to_map(local_coords)
	
	for i in range(get_layers_count()-1,-1,-1):
		if(layer_disabled.has(i)): continue
		var cell = get_cell_atlas_coords(i,tilemap_coords)
		if cell != Vector2i(-1,-1):
			return i
			
	return -1
			


func _on_button_gui_input(event):
	if event is InputEventMouseMotion:
		_on_hover()
