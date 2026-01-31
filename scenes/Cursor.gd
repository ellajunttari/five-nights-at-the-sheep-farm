extends Sprite2D

@onready var reset_timer: Timer = Timer.new()


func _enter_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	reset_timer.one_shot = true
	reset_timer.wait_time = 0.10
	reset_timer.timeout.connect(_on_reset_timer_timeout)
	add_child(reset_timer)

	frame_coords = Vector2i(0, 0)


func _process(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_HIDDEN:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _physics_process(delta: float) -> void:
	global_position = lerp(
		global_position,
		get_global_mouse_position(),
		16.5 * delta
	)


func _input(event) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		frame_coords = Vector2i(1, frame_coords.y)
		reset_timer.start()


func _on_reset_timer_timeout() -> void:
	frame_coords = Vector2i(0, frame_coords.y)
