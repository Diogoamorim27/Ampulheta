"""
Base interface for all states: it doesn't do anything in itself
but forces us to pass the right arguments to the methods below
and makes sure every State object had all of these methods.
"""
extends Node

const UP = Vector2(0, -1)
const AIR_SPEED = 16000
const JUMP = -700
const GRAVITY = 1000
const WALL_JUMP_RECOIL = 20000

var motion = Vector2()
var walljump = 0

signal finished(next_state_name)

func _ready():
	owner.get_node("AnimationPlayer").connect("animation_finished", self, "_on_animation_finished")
	connect("finished", owner, "_change_state")
	
# Initialize the state. E.g. change the animation
func enter():
	#print("i jumped")
	#motion.y = JUMP
	
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	motion = Vector2()
	#walljump = 0
	return

func _handle_input():
	var direction = Vector2()
	if Input.is_action_pressed("ui_accept") || Input.is_action_pressed("ui_up"):
		direction.y = 1
	if Input.is_action_pressed("ui_right"):  
		direction.x += 1
	if Input.is_action_pressed("ui_left"): 
		direction.x -= 1
			
	return direction
	

func update(delta):
	motion.y += delta * GRAVITY
	owner.move_and_slide(motion, UP)
	
	if motion.y > 0:
		owner.get_node("AnimationPlayer").play("Jump")
	
	var input_direction = _handle_input()
	if owner.is_on_floor():
		#walljump = 0
		if input_direction.y:
			#owner.get_node("AnimationPlayer").play("Jump")
			motion.y = JUMP
		else:
			if input_direction.x:
				emit_signal("finished", "move")
			else:
				emit_signal("finished", "idle")
	
	if !owner.is_on_floor() and owner.is_on_wall():
		emit_signal("finished", "walljump")
		
	if input_direction.x > 0:
		owner.get_node("Sprite").flip_h = true
	elif input_direction.x < 0:
		owner.get_node("Sprite").flip_h = false
	
	if input_direction.x:
		#if walljump == 0:
		motion.x = input_direction.x * AIR_SPEED * delta
	else: 
			#if (input_direction.x > 0 and motion.x < 0) or (input_direction.x > 0 and motion.x < 0):
		motion.x = lerp(motion.x, 0, 0.05)

	if owner.is_on_ceiling():
		motion.y = 0
	
	return

func _on_animation_finished(anim_name):
	if motion.y > 0:
		owner.get_node("AnimationPlayer").play("Fall")
	else:
		owner.get_node("AnimationPlayer").play("Jump")
	return
