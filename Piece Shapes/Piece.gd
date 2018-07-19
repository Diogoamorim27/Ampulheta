extends Node

const DOWN = Vector2(0, 1)
const MAX_SPEED = 400

var grid
var type
var can_move = 0
var velocity = Vector2(0,0)
var is_moving = 0
var target_position
var speed
var downpress = 0
var position_in_grid 
var pos

func _ready():
	pos = position_in_grid
	$Timer.connect("timeout", self, "_on_timer_timeout")
	grid = get_parent()
	type = grid.BLOCK
	pass
	
	
func _physics_process(delta):
	can_move = 1
	if downpress: #&& !is_on_floor(): as pecas mais em baixo precisam ser testadas
		if !is_moving:
			for child in get_children():
				if child.name != "Timer":
					grid.grid[grid.world_to_map(child.global_position).x][grid.world_to_map(child.global_position).y] = null
					#print(grid.grid[grid.world_to_map(child.global_position).x][grid.world_to_map(child.global_position).y])
					if !grid.is_cell_vacant(grid.world_to_map(child.global_position) + DOWN):
						can_move = 0

			if can_move:
				target_position = self.position + grid.map_to_world(DOWN) #grid.map_to_world(DOWN)
				if target_position != self.position:
					is_moving = 1
			else:
				for child in get_children():
					if child.name != "Timer":
						grid.grid[grid.world_to_map(child.global_position).x][grid.world_to_map(child.global_position).y] = type
		elif is_moving:
			speed = MAX_SPEED
			velocity = speed * DOWN * delta
			
			var distance_to_target = Vector2(0, target_position.y - self.position.y)
			
			if abs(velocity.y) > distance_to_target.y:
				velocity.y = abs(distance_to_target.y) * DOWN.y
				is_moving = 0
				downpress = 0
				for child in get_children():
					if child.name != "Timer":
						grid.grid[grid.world_to_map(child.global_position).x][grid.world_to_map(child.global_position).y] = type
						#print(grid.grid[grid.world_to_map(child.global_position).x][grid.world_to_map(child.global_position).y])
				
			move_and_collide(velocity)
							
			
	
func _on_timer_timeout():
	downpress = 1
