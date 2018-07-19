extends RayCast2D

signal player_died


func _ready():
	self.cast_to.y = get_parent().get_node("Sprite").texture.get_size().y/2
	connect("player_died", get_parent().get_parent().get_parent(), "kill_player")
	

		
func _process(delta):
	if is_colliding() and get_collider().name != "Player":
		$SpikeDown.visible = false
		print(get_collider().name)