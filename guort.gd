extends CharacterBody2D

@export var up_neighbour = null
@export var down_neighbour = null

signal landed
func _ready() -> void:
	landed.connect(on_stop)

var prev_velocity = 0
func track_if_stopped():
	if velocity.x == 0 and prev_velocity != 0:
		on_stop()
	prev_velocity = velocity.x

func on_stop():
	$Body.idle()
	$Body/Face.idle()
	

var prev_on_floor = false
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		prev_on_floor = false
		velocity += get_gravity() * delta
		$Body.play("restive")
	elif prev_on_floor == false:
		landed.emit()
		prev_on_floor = true

	var target = Input.get_axis("go_left","go_right") * 200
	if not down_neighbour:
		velocity.x = move_toward(velocity.x, target, 20)
		if not velocity.x == 0:
			$Body.play("transportative")
			$Body.flip_h = velocity.x > 0
			$Body/Face.flip_h = velocity.x > 0
	track_if_stopped()

	move_and_slide()
