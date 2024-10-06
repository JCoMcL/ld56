extends Camera2D

# Export variables for easy adjustment in the editor
@export var target_node: NodePath
@export_range(0, 1, 0.01) var mouse_influence: float = 0.5  # 0 = no mouse influence, 1 = full mouse influence
@export var camera_speed: float = 5.0     # How fast the camera moves
@export var mouse_deadzone: float = 100.0 # Radius around screen center where mouse has no effect

# Zoom-related exports
@export var reference_resolution: Vector2 = Vector2(1920, 1080)  # The resolution you're designing for
@export_range(0.2, 10, 0.1) var zoom_factor: float = 1

# Internal variables
var target: Node2D = null
var viewport_size: Vector2
var screen_center: Vector2
var current_velocity: Vector2 = Vector2.ZERO
var initial_pos: Vector2

func _ready():	
	viewport_size = get_viewport().size
	screen_center = viewport_size / 2
	initial_pos = position

func adjust_zoom():
	viewport_size = get_viewport().size
	screen_center = viewport_size / 2
	
	# Calculate zoom based on screen size
	var zoom_x = viewport_size.x / reference_resolution.x
	var zoom_y = viewport_size.y / reference_resolution.y
	
	# Use the smaller zoom value to ensure the game area fits on screen
	var new_zoom = min(zoom_x, zoom_y)
	
	# Apply zoom
	zoom = Vector2(new_zoom, new_zoom) * zoom_factor

func _process(delta):
	adjust_zoom()
	if position.y > limit_bottom * 2:
		get_tree().current_scene.restart()

	var target_pos = initial_pos
	if target:
		target_pos = target.global_position

	# Calculate mouse influence
	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_offset = mouse_pos - screen_center
	
	# Apply deadzone
	if mouse_offset.length() < mouse_deadzone:
		mouse_offset = Vector2.ZERO
	else:
		mouse_offset -= mouse_offset.normalized() * mouse_deadzone
	
	# Calculate desired camera position
	var mouse_target = global_position + mouse_offset * mouse_influence
	var final_target = lerp(target_pos, mouse_target, mouse_influence)
	
	# Smoothly move camera towards target
	var ideal_position = final_target - offset
	global_position = global_position.lerp(ideal_position, camera_speed * delta)

# Optional method to change target at runtime
func set_tracking_target(new_target: Node2D):
	target = new_target

# Optional method to set mouse influence at runtime
func set_mouse_influence(influence: float):
	mouse_influence = clamp(influence, 0.0, 1.0)
