@tool
extends AnimationPlayer

enum State {OPEN, CLOSED}
@export var state: State:
	set(seconds):
		print(current_animation, current_animation_position)
		seek(seconds, true)
		print(current_animation, current_animation_position)
		state = seconds
		
