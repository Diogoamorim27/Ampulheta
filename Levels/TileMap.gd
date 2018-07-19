extends TileMap


var tile_size  = self.cell_size
var half_tile_size = self.cell_size/2
var grid_size = Vector2(10, 52)
var grid = []


var block_object = preload("res://Blocks/ObstacleBlocks/NeutralBlock1/ObstacleBlock1.tscn")
var piece_object = preload("res://Piece Shapes/Piece.tscn")

enum ERRORS {OK, CELL_IS_OCCUPIED}
enum GRID_OBJECTS {PLAYER, BLOCK}

onready var shapes = $shapes.shapes
onready var piece = $shapes.shapes[randi() % 19]

func _ready():
	
	# CONNECT THE SIGNALS TO THE FUNCTIONS #
	$SpawnTimer.connect("timeout", self, "_on_spawn_timer_timeout")
	
	# CREATE GRID MATRIX #
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
			
	
## vai para script da peca ##
func is_cell_vacant(pos):
	if pos.x < grid_size.x and pos.x >= 0:
		if pos.y < grid_size.y and pos.y >= 0:
				if grid[pos.x][pos.y] == null:
					return true
	return false
	
func _process(delta):
	var player_tile = world_to_map($Player.position)
	if grid[player_tile.x][player_tile.y] != null:
		print("player is dead")
		$Player/States/Die.enter()
	
	pass

## level contains info about special blocks and normal/special block ratios ##
func _spawn_piece(level, piece, pos):
	for block in piece:
		if !is_cell_vacant(pos + block):
			return CELL_IS_OCCUPIED
			print("deu ruim")
	var new_piece = piece_object.instance()
	new_piece.position = map_to_world(pos) #+ half_tile_size
	add_child(new_piece)
	for block in piece:
		var object = block_object.instance()
		object.position = map_to_world(block) + half_tile_size 
		grid[(pos + block).x][(pos + block).y] = BLOCK
		new_piece.add_child(object)
	#print(piece_array)
	return OK

func _on_spawn_timer_timeout():
	var piece_shape
	var spawn_spot
	randomize()
	piece_shape = $shapes.shapes[randi() % 19]
	randomize()
	spawn_spot = Vector2(randi() % 10, 0)
	if !$Camera2D.has_stopped:
		spawn_spot.y = world_to_map($Camera2D.position).y - 8
		if _spawn_piece(1, piece_shape, spawn_spot) == CELL_IS_OCCUPIED:
			randomize()
			spawn_spot.x = randi() % 10
			_spawn_piece(1, piece_shape, spawn_spot)
	pass
		

