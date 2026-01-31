extends Sprite2D

@onready var reset_timer := Timer.new()


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	# Setup timer
	reset_timer.one_shot = true
	reset_timer.wait_time = 1.0
	reset_timer.timeout.connect(_on_reset_timer_timeout)
	add_child(reset_timer)

	# Start on idle frame
	frame_coords = Vector2i(0, frame_coords.y)


func _physics_process(delta: float) -> void:
	global_position = lerp(
		global_position,
		get_global_mouse_position(),
		16.5 * delta
	)


func _unhandled_input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		# Switch to click frame
		frame_coords = Vector2i(1, frame_coords.y)

		# Restart timer every click
		reset_timer.start()


func _on_reset_timer_timeout():
	# Return to idle frame
	frame_coords = Vector2i(0, frame_coords.y)
