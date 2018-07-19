extends KinematicBody2D


onready var idle = $States/Idle
onready var move = $States/Move
onready var jump = $States/Jump
onready var walljump = $States/WallJump
onready var die = $States/Die

var state


func _ready():
	state = idle
	state.connect("finished", self, "_change_state")
	get_parent().get_node("Camera2D").connect("die", self, "_change_state")
	state.enter()
	pass

func _physics_process(delta):
	state.update(delta)
	pass

func _change_state(next_state_name):
	state.exit()
	var state_name = next_state_name
	if state_name == "move":
		state = move
	elif state_name == "idle":
		state = idle
	elif state_name == "jump":
		state = jump
	elif state_name == "walljump":
		state = walljump
	elif state_name == "die":
		state = die
	state.enter()
	pass