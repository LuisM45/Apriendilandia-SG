var rng = RandomNumberGenerator.new()

var dimension = Vector2i(0,0)

var pos_current = Vector2i(0,0)
var pos_start = Vector2i(0,0)
var pos_final = Vector2i(0,0)

var final_maze = []
var dirty_maze = []
var unused_spaces = []

func _init(width,height):
	# 1
	self.dimension = Vector2i(width,height)


func generate():
	create_matrixes()
	pos_start = unused_spaces.pop_front()
	pos_final = unused_spaces.pop_front()
	pos_current = pos_start
	
	walk_first()
	append_maze_first()
	while walk_other():
		append_maze()
		


func create_matrixes():
	_create_matrix(final_maze)
	_create_matrix(dirty_maze)
	for j in range(dimension.y):
		for i in range(dimension.x):
			unused_spaces.append(Vector2i(i,j))
	unused_spaces.shuffle()

func _create_matrix(matrix):
	matrix.clear()
	for i in range(dimension.y):
		var row = []
		for j in range(dimension.x):
			row.append(Vector2i(0,0))
			
		matrix.append(row)

func walk_first():
	var direction = Vector2i(0,0)
	while pos_current!=pos_final:
		direction = random_direction()
		dirty_maze[pos_current.y][pos_current.x] = direction
		pos_current += direction
		
	dirty_maze[pos_current.y][pos_current.x] = -direction 

func walk_other():
	while final_maze[pos_start.y][pos_start.x] != Vector2i(0,0):
		if unused_spaces.size() == 0: return false
		pos_start = unused_spaces.pop_front()
		
	pos_current = pos_start
	
	while final_maze[pos_current.y][pos_current.x] == Vector2i(0,0):
		var direction = random_direction()
		dirty_maze[pos_current.y][pos_current.x] = direction
		pos_current += direction
	
	pos_final = pos_current
	return true

func random_direction():
	var options = []
	if (pos_current.x > 0): options.append(Vector2i(-1,0))
	if (pos_current.y > 0): options.append(Vector2i(0,-1))
	if (pos_current.x < dimension.x-1): options.append(Vector2i(1,0))
	if (pos_current.y < dimension.y-1): options.append(Vector2i(0,1))
	
	return options.pick_random()

	
func append_maze_first():
	append_maze()
	final_maze[pos_final.y][pos_final.x] = dirty_maze[pos_final.y][pos_final.x]
	
func append_maze():
	pos_current = pos_start
	while pos_current!= pos_final:
		var direction = dirty_maze[pos_current.y][pos_current.x]
		final_maze[pos_current.y][pos_current.x] = direction
		pos_current += direction
	
