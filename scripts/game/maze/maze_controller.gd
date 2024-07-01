# Dont forget to credit
extends TileMap

@export var difficulty = 6

const maze_gen_class = preload("res://scripts/game/maze/maze_generator.gd")
const cell_thickness = 2
var maze_gen = null
var tile_cells = {}
var adjusted_tile_size = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func generate():
	empty_maze()
	maze_gen = maze_gen_class.new(difficulty,difficulty)
	maze_gen.generate()
	fill_base_maze()
	draw_generated_maze()
	place_holes()
	paint_cells()
	
	var base_size = (maze_gen.dimension*2+Vector2i.ONE)*tile_set.tile_size*cell_thickness
	var y_factor = get_viewport_rect().size.y / base_size.y
	scale = Vector2(y_factor,y_factor)
	var tilemap_size = Vector2(base_size)*scale
	adjusted_tile_size = tile_set.tile_size.y*y_factor
	
	position.x = get_viewport_rect().size.x /2
	position.x -= tilemap_size.x/2

func fill_base_maze():
	for j in range(maze_gen.dimension.y):
		for i in range(maze_gen.dimension.x*2+1):
			append_cell(Vector2i(i,j*2))
		for i in range(maze_gen.dimension.x+1):
			append_cell(Vector2i(i*2,j*2+1))
		
	for i in range(maze_gen.dimension.x*2+1):
		append_cell(Vector2i(i,maze_gen.dimension.y*2))

func draw_generated_maze():
	for j in maze_gen.dimension.y:
		for i in maze_gen.dimension.x:
			var target_cell_in_graph = Vector2i(1+2*i,1+2*j)
			
			var direction = maze_gen.final_maze[j][i]
			remove_cell(target_cell_in_graph+direction)

func append_cell(cell:Vector2i):
	tile_cells[cell] = true

func remove_cell(cell:Vector2i):
	tile_cells.erase(cell)

func paint_cells():
	var new_tc = []
	for c in tile_cells.keys():
		for w in range(cell_thickness):
			for h in range(cell_thickness):
				new_tc.append(c*cell_thickness+Vector2i(w,h))
	set_cells_terrain_connect(0,new_tc,0,1)

func place_holes():
	var hole_height = maze_gen.dimension.y*2+1
	var last_wall = maze_gen.dimension.x*2
	remove_cell(Vector2i(0,3))
	remove_cell(Vector2i(last_wall,hole_height-4))

func empty_maze():
	for cell in tile_cells.keys():
		set_cell(0,cell)
	clear()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
