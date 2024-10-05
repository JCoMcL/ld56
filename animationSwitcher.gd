extends AnimatedSprite2D

@export var idle_animations: Array[StringName] = []
var rng = RandomNumberGenerator.new()

func idle():
	play(idle_animations.pick_random())
	
func _ready() -> void:
	if not idle_animations.size():
		for s in sprite_frames.get_animation_names():
			idle_animations.append(StringName(s))
	idle()

func _process(delta: float) -> void:
	pass
