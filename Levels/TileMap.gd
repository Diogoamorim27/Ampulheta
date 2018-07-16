extends TileMap


var tile_size  = self.cell_size
var half_tile_size = self.cell_size/2
var grid_size = Vector2(10, 52)
var grid = []
var piece_array = []


var block_object = preload("res://Blocks/ObstacleBlocks/NeutralBlock1/ObstacleBlock1.tscn")

enum ERRORS {OK, CELL_IS_OCCUPIED}
enum GRID_OBJECTS {PLAYER, BLOCK}

onready var shapes = $shapes.shapes
onready var piece = $shapes.shapes[randi() % 19]

func _ready():
	$MovementTimer.connect("timeout", self, "_on_timer_timeout")
	# CREATE GRID MATRIX #
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
	print(piece)
	print(_spawn_piece(1, $shapes.shapes[randi() % 19], Vector2(3,45)))
	#randomize()
	#print(_spawn_piece(1, $shapes.shapes[randi() % 19], Vector2(6,2)))
			
	
func _is_cell_vacant(pos):	
	if pos.x < grid_size.x and pos.x >= 0:
		if pos.y < grid_size.y and pos.y >= 0:
			return true if grid[pos.x][pos.y] == null else false
	return false
	
func _process(delta):
	pass

func _spawn_piece(level, piece, pos):
	var block_array = []
		## level contains info about special blocks and normal/special block ration ##
		## piece is an array of Vector2()s ##
	for block in piece:
		if !_is_cell_vacant(pos + block):
			return CELL_IS_OCCUPIED
	for block in piece:
		var object = block_object.instance()
		object.position = map_to_world(pos + block) + half_tile_size
		grid[(pos + block).x][(pos + block).y] = BLOCK
		add_child(object)
		block_array.append(object) 
	piece_array.append(block_array)
	print(piece_array)
	return OK
		
func _move_pieces(piece_array):
	for piece in piece_array:
		for block in piece:
			if !_is_cell_vacant(world_to_map(block.position) + Vector2(0,1)):
				print("cell not vacant")
				piece_array.remove(piece_array.find(piece))
				return
				
				#print("piece removed")
			else:
				grid[world_to_map(block.position).x][world_to_map(block.position).y] = null
				block.position = block.position + map_to_world(Vector2(0,1))
				grid[world_to_map(block.position).x][world_to_map(block.position).y] = BLOCK
				
func _on_timer_timeout():
	_move_pieces(piece_array)