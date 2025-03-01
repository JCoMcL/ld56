extends AnimatedSprite2D

@export var up_neighbour = null
@export var down_neighbour = null

var available: bool = true

enum {UP, DOWN}

var transition_table = {
	"poked up": "idle"
}
func animation_transition():
	available = true
	play("idle", 0)
	pick_new_frame()
		
# Called when the node enters the scene tree for the first time.
var rng = RandomNumberGenerator.new()
func pick_new_frame():
	var frame_count = sprite_frames.get_frame_count(animation)
	frame = rng.randi_range(0, frame_count-1)
	set_frame_timer()

func set_timer(timer, avg_time, callback):
	var time = rng.randi_range(0,avg_time) + rng.randi_range(0,avg_time)
	timer.one_shot = true
	if not timer.timeout.is_connected(callback):
		timer.timeout.connect(callback)
	timer.start(time)

func set_frame_timer():
	set_timer($Timer, 2, pick_new_frame)
func set_sleepy_timer():
	set_timer($Sleepytime, 7, go_to_sleep)
	
func go_to_sleep():
	play("sleep")
	available = false

func on_input(viewport: Node, event: InputEvent, shape_id: int):
	if event.is_action_pressed("poke"):
		var neighbours = []
		if up_neighbour and up_neighbour.available:
			neighbours.push_back(up_neighbour)
		if down_neighbour and down_neighbour.available:
			neighbours.push_back(down_neighbour)
		if neighbours.size():
			var winner = neighbours.pick_random()
			match winner:
				up_neighbour: winner.poke(DOWN)
				down_neighbour: winner.poke(UP)
		
func poked(direction: int):
	match direction:
		UP:
			play("poked up")
		DOWN:
			play("poked down")
	set_sleepy_timer()

func poke(direction: int):
	match direction:
		UP:
			play("poke up")
			up_neighbour.poked(UP)
		DOWN:
			play("poke down")
			down_neighbour.poked(DOWN)
		
func _ready() -> void:	
	animation_finished.connect(animation_transition)
	play("idle", 0)
	set_frame_timer()
	set_sleepy_timer()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
