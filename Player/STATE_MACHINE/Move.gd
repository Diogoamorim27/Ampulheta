"""
Base interface for all states: it doesn't do anything in itself
but forces us to pass the right arguments to the methods below
and makes sure every State object had all of these methods.
"""
extends Node

const UP = Vector2(0, -1)
const SPEED = 20000
const GRAVITY = 1000

var motion = Vector2()

signal finished(next_state_name)

func _ready():
	owner.get_node("AnimationPlayer").connect("animation_finished", self, "_on_animation_finished")
	connect("finished", owner, "_change_state")

# Initialize the state. E.g. change the animation
func enter():
	owner.get_node("AnimationPlayer").play("Move")
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	#nothing to clean up
	return

func _handle_input():
	var direction = Vector2()
	if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_up"):
		direction.y = 1
	elif Input.is_action_pressed("ui_right"):  
		direction.x += 1
	if Input.is_action_pressed("ui_left"): 
		direction.x -= 1
			
	return direction
	

func update(delta):
	if owner.is_on_floor():
		motion.y = 0
	var input_direction = _handle_input()

	if !input_direction:
		emit_signal("finished", "idle")
	elif input_direction.y:
		if owner.is_on_wall():
			emit_signal("finished", "walljump")
		else:
			emit_signal("finished", "jump")
		emit_signal("finished", "jump")
	else:
		if input_direction.x > 0:
			owner.get_node("Sprite").flip_h = true
		else:
			owner.get_node("Sprite").flip_h = false
		
	motion.x = input_direction.x * delta * SPEED
	motion.y += delta * GRAVITY
	if motion.y > (GRAVITY + 1)*delta:
		emit_signal("finished", "jump")
	owner.move_and_slide(motion, UP)	 #, 5, 2)
	
			#emit_signal("finished", "jump")
	return

func _on_animation_finished(anim_name):
	owner.get_node("AnimationPlayer").play("Move")
	return
