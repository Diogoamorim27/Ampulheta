"""
Base interface for all states: it doesn't do anything in itself
but forces us to pass the right arguments to the methods below
and makes sure every State object had all of these methods.
"""
extends Node

signal finished(next_state_name)

func _ready():
	owner.get_node("AnimationPlayer").connect("animation_finished", self, "_respawn")

# Initialize the state. E.g. change the animation
func enter():
	owner.get_node("AnimationPlayer").play("Die")
	print("entered death cycle")
	get_tree().reload_current_scene()
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event):
	return

func update(delta):
	return

func _on_animation_finished(anim_name):
	return
	
func _respawn(anim_name):
	print("entered respawn function")
	if anim_name == "Die":
		get_tree().reload_current_scene()
	pass
