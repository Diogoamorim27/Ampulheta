"""
Base interface for all states: it doesn't do anything in itself
but forces us to pass the right arguments to the methods below
and makes sure every State object had all of these methods.
"""
extends Node

const JUMP = -700
const WALL_JUMP_RECOIL = 200
const AIR_SPEED = 16000
const GRAVITY = 1000
const UP = Vector2(0, -1)

var right_jump_counter = 0
var left_jump_counter = 0
var motion = Vector2()

signal finished(next_state_name)

func _ready():
	owner.get_node("AnimationPlayer").connect("animation_finished", self, "_on_animation_finished")
	connect("finished", owner, "_change_state")

# Initialize the state. E.g. change the animation
func enter():
	owner.get_node("AnimationPlayer").play("WallJump")
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	right_jump_counter = 0
	left_jump_counter = 0
	return

func _handle_input():
	var direction = Vector2(0,0)
	if Input.is_action_pressed("ui_accept") || Input.is_action_pressed("ui_up"):
		direction.y = 1
	if Input.is_action_pressed("ui_right"):  
		direction.x += 1
	if Input.is_action_pressed("ui_left"): 
		direction.x -= 1
			
	return direction

func update(delta):
	var input_direction = _handle_input()
	if owner.is_on_wall():
		owner.get_node("AnimationPlayer").play("WallJump")
	if owner.is_on_floor():
		motion.y = 0
		emit_signal("finished", "idle")
	
	if owner.get_node("RayCast2DLeft").is_colliding() and owner.is_on_wall():
		if left_jump_counter < 2 and input_direction.y:
			right_jump_counter = 0
			left_jump_counter += 1
			motion.y = JUMP
		
	if owner.get_node("RayCast2DRight").is_colliding() and owner.is_on_wall():
		if right_jump_counter < 2 and input_direction.y:
			left_jump_counter = 0
			right_jump_counter += 1
			print(right_jump_counter)
			motion.y = JUMP

	if !owner.is_on_wall():
		if motion.y > 0:
			owner.get_node("AnimationPlayer").play("Jump")
		#else:
			#owner.get_node("AnimationPlayer").play("Fall")

	if input_direction.x > 0:
		owner.get_node("Sprite").flip_h = true
	elif input_direction.x < 0:
		owner.get_node("Sprite").flip_h = false
	
	if input_direction:
		motion.x = input_direction.x * AIR_SPEED * delta
	
	else:
		motion.x = lerp(motion.x, 0, 0.05)
	motion.y += GRAVITY * delta
	
	owner.move_and_slide(motion, UP)
	
	return

func _on_animation_finished(anim_name):
	if owner.is_on_floor():
		owner.get_node("AnimationPlayer").play("Idle")
	elif owner.is_on_wall():
		owner.get_node("AnimationPlayer").play("WallJump")
	return
