extends "res://animationSwitcher.gd"

func pick_new_idle():
	super.pick_new_idle()
	$Face.pick_new_idle()

func idle(pick_new: bool = false):
	super.idle(pick_new)
	$Face.idle(pick_new)

func play_exclusive(s: StringName):
	play(s)
	$Face.visible = false
	
func on_exclusive_finished():
	$Face.visible = true
	
func _ready() -> void:
	animation_changed.connect(on_exclusive_finished)
	super._ready()
