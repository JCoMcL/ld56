extends CharacterBody2D

@export var up_neighbour = null
@export var down_neighbour = null
enum Direction {LEFT, RIGHT}
@export var facing: Direction
@export var label: String = "Guort with no name"
@export var sleeping = false

signal landed
signal stopped

func attach(gourt: Node):
	if up_neighbour:
		up_neighbour.attach(gourt)
	else:
		$Socket.add_child(gourt)
		up_neighbour = gourt
		gourt.down_neighbour = self
	
func _ready() -> void:
	landed.connect(on_stop)
	stopped.connect(on_stop)
	identify()

func set_facing(direction: int):
	if direction != facing:
		flip()
	facing = direction

func identify(additional_remark: String = ""):
	print("I, {0}, am feeling {1}! {2}".format([label, feeling(), additional_remark]))

func feeling():
	return "{0}ly {1}".format([$Body.animation, $Body/Face.animation])

func flip_self():
	for c in [$CollisionShape2D, $Body]:
		c.transform.x *=-1
func flip_socket():
	$Socket.flip()	
func flip():
	flip_self()
	flip_socket()
		
var prev_velocity = 0
func track_if_stopped():
	if velocity.x == 0 and prev_velocity != 0:
		on_stop()
	prev_velocity = velocity.x

var prev_on_floor = false
func track_if_landed():
	if is_on_floor() and not prev_on_floor:
		landed.emit()
	prev_on_floor = is_on_floor()
	
func on_stop():
	idle()

func idle(new_idle=false):
	$Body.idle(new_idle)
	$Body/Face.idle(new_idle)
	
	
func bottom_behaviour(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		$Body.play("restive")

	var target = Input.get_axis("go_left","go_right") * 200
	if not down_neighbour:
		velocity.x = move_toward(velocity.x, target, 20)
		if not velocity.x == 0:
			$Body.play("transportative")
			set_facing(int(velocity.x > 0))
	track_if_stopped()
	track_if_landed()
	move_and_slide()

func _physics_process(delta: float) -> void:
	if down_neighbour == null:
		bottom_behaviour(delta)

# Behaviours
func sleep():
	$Body.play("palliative")
	$Body/Face.play("sleep")
	sleeping = true
	$ClickDetector.inhibit()
func wakeup():
	sleeping = false
	$ClickDetector.enable()
	idle()
		
