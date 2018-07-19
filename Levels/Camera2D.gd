extends Camera2D

const SPEED = 60

var camera_standart_position
var camera_movement = 0
var grid
signal die

func _ready():
	grid = get_parent()
	camera_standart_position = self.position.y
	$Timer.connect("timeout", self, "_on_timer_timeout")
	$DeathZone.connect("body_entered", self, "_die")
	pass

func _process(delta):
	if camera_movement:
		#var bodies = $MovementZone.get_overlapping_bodies()
		#for body in bodies:
		#if body.name == "Player":
			#	if body.position.y < camera_standart_position:
				#	self.position.y = body.position.y
			#else:
		self.position.y = camera_standart_position
		
		camera_standart_position -= delta * SPEED

	if grid.world_to_map(self.global_position).y <= 5:
		camera_movement = 0

	pass
	
func _on_timer_timeout():
	camera_movement = 1
	pass
	
func _die(object):
	if object == get_parent().get_node("Player"):
		emit_signal("die")
		print("char is dead")