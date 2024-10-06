extends AnimatedSprite2D

@export var idle_animations: Array[StringName] = []
@export var reserved_animations: Array[StringName] = []
var rng = RandomNumberGenerator.new()

func transition():
	idle()

var current_idle
func pick_new_idle():
	current_idle = idle_animations.pick_random()

func idle(pick_new: bool = false):
	if pick_new or not current_idle:
		pick_new_idle()
	play(current_idle)
	
func _ready() -> void:
	animation_finished.connect(transition)
	if not idle_animations.size():
		for s in sprite_frames.get_animation_names():
			if s not in reserved_animations:
				idle_animations.append(StringName(s))
	idle()
