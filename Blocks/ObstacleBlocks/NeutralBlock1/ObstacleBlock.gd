extends StaticBody2D

const TEXTURES = [
"res://Blocks/Enviroment Blocks/rock_1_10.png",
"res://Blocks/Enviroment Blocks/rock_1_20.png",
"res://Blocks/Enviroment Blocks/rock_1_30.png",
"res://Blocks/Enviroment Blocks/rock_1_40.png",
"res://Blocks/Enviroment Blocks/rock_1_50.png",
"res://Blocks/Enviroment Blocks/rock_1_60.png"]
const SPRITE_SCALE = Vector2(0.301887,0.301887)

func _ready():
	randomize()
	$Sprite.set_texture(load(TEXTURES[randi() % 6]))
	$Sprite.set_scale(SPRITE_SCALE)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
