extends Camera2D

const SPEED = 45

var camera_standart_position
var camera_movement = 0
var grid
var has_stopped = 0
var is_on_player
signal die

func _ready():
	grid = get_parent()
	camera_standart_position = self.position.y
	$Timer.connect("timeout", self, "_on_timer_timeout")
	$DeathZone.connect("body_entered", self, "_die")
	$MovementZone.connect("body_entered", self, "_follow_player")
	#$MovementZone.connect("body_exited", self, "_leave_player")
	pass

func _process(delta):
	
	self.position.y = camera_standart_position
#	if is_on_player && get_parent().get_node("Player").position.y < camera_standart_position:
#		self.global_position.y = get_parent().get_node("Player").global_position.y

#	elif camera_movement: # and !is_on_player:
#		self.position.y = camera_standart_position
#		is_on_player = 0
	if camera_movement:
		camera_standart_position -= SPEED * delta
		
	if grid.world_to_map(self.global_position).y <= 5:
		camera_movement = 0
		has_stopped = 1

	pass
	
func _on_timer_timeout():
	camera_movement = 1
	pass
	
func _die(object):
	if object == get_parent().get_node("Player"):
		emit_signal("die", "die")
		print("char is dead")
		
func _follow_player(player):
	if player.name == "Player":
		is_on_player = 1