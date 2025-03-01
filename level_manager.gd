extends Node

@export var start_scene: PackedScene
var level_scene

var level
func add_level():
	level = level_scene.instantiate()
	add_child(level)

func _ready() -> void:
	level_scene = start_scene
	add_level()

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		print("restarting")
		restart()
	
func reset_level(variable):
	print("beginning reset")
	remove_child(level)
	level.queue_free()
	add_level()
	$AnimationPlayer.animation_finished.disconnect(reset_level)
	$AnimationPlayer.play("open")

func restart_game():
	level_scene = start_scene
	restart()

func new_level(new_level_scene: PackedScene):
	level_scene = new_level_scene
	restart()
	
func restart():
	$AnimationPlayer.play("close")
	if not $AnimationPlayer.animation_finished.is_connected(reset_level):
		$AnimationPlayer.animation_finished.connect(reset_level)
	
	
	
