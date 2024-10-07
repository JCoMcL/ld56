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


func set_timer(timer, avg_time, callback):
	var time = randi_range(0,avg_time) + randi_range(0,avg_time)
	timer.one_shot = true
	if not timer.timeout.is_connected(callback):
		timer.timeout.connect(callback)
	timer.start(time)

func bump_patience():
	if $Patience.time_left:
		$Patience.start($Patience.time_left + 1)
	else:
		set_timer($Patience, 24, on_patience_expired)

func on_patience_expired():
	sleep()

func _ready() -> void:
	landed.connect(on_stop)
	stopped.connect(on_stop)
	$ClickDetector.nearby_click.connect(on_nearby_click)
	$Body.animation_finished.connect(on_animation_end)
	set_timer($Patience, 15, sleep)
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

func nothing():
	pass
var do_on_animation_end = nothing
func on_animation_end():
	do_on_animation_end.call()
	do_on_animation_end = nothing
	
func idle(new_idle=false):
	$Body.idle(new_idle)
	
func bottom_behaviour(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		$Body.play("restive")

	var target = Input.get_axis("go_left","go_right") * 200 if input_enabled else 0
	velocity.x = move_toward(velocity.x, target, 20)
	if not velocity.x == 0:
		if do_on_animation_end == nothing:
			$Body.play("transportative")
			set_facing(int(velocity.x > 0))
	track_if_stopped()
	track_if_landed()
	move_and_slide()

func on_nearby_click(where: Vector2):
	if input_enabled:
		if where.y < 0:
			poke_up()
		else:
			poke_down()
	else:
		identify("input disabled")

func _physics_process(delta: float) -> void:
	if down_neighbour == null:
		bottom_behaviour(delta)

var input_enabled = true
func disable_input():
	input_enabled = false
func enable_input():
	input_enabled = true
func disable_input_for_animation():
	on_animation_end()
	disable_input()
	do_on_animation_end = enable_input
func offset_face_for_animation(offset: Vector2):
	on_animation_end()
	var saved_pos = $Body/Face.get_position()
	$Body/Face.position += offset
	do_on_animation_end = func():
		$Body/Face.position = saved_pos
# Behaviours
func sleep():
	$Body.play(["palliative", "restive"].pick_random())
	$Body/Face.play("sleep")
	disable_input_for_animation()
	sleeping = true
	$ClickDetector.inhibit()
	$Socket.position.y = -60
	$Body/SleepyParticles.emitting = true
	$SleepySFX.play()
func wakeup():
	sleeping = false
	$ClickDetector.enable()
	$Socket.position.y = -88
	$Body/SleepyParticles.emitting  = false
	$SleepySFX.stop()
func poke_up():
	offset_face_for_animation(Vector2(20,-20))
	$Body.play("poke_up")
	up_neighbour.poked()
func poke_down():
	offset_face_for_animation(Vector2(-20,20))
	$Body.play("poke_down")
	down_neighbour.poked()
func poked():
	bump_patience()
	wakeup()
	disable_input_for_animation()
	$Body.play_exclusive(["shock_0", "shock_1", "shock_2"].pick_random())
	$Body.pick_new_idle()
		
