
extends Node

signal finished(next_state_name)

func _ready():
	owner.get_node("AnimationPlayer").connect("animation_finished", self, "_on_animation_finished")
	
# Initialize the state. E.g. change the animation
func enter():
	owner.get_node("AnimationPlayer").play("Idle")
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	#nothing to clean up
	return

func _handle_input():
	var direction = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1 
		pass
	if Input.is_action_just_pressed("ui_left"): 
		direction.x -= 1
		pass
	if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_up"):
		direction.y = 1
	return direction
	

func update(delta):
	var input_direction = _handle_input()
	if input_direction.y:
		if owner.is_on_wall():
			emit_signal("finished", "walljump")
		else:
			emit_signal("finished", "jump")
	elif input_direction.x:
		emit_signal("finished", "move")
		
	if !owner.is_on_floor(): 
		emit_signal("finished", "jump")
func _on_animation_finished(anim_name):
	owner.get_node("AnimationPlayer").play("Idle")
	return