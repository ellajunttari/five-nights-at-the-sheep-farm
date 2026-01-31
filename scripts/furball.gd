extends RigidBody2D

var is_held = false

func _ready():
	# Ensure the wool doesn't fall off the sheep immediately
	freeze = true
	add_to_group("draggables")

func _input_event(_viewport, event, _shape_idx):
	# Check for a left mouse button click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# We only trigger on the "pressed" state to avoid double-triggering on release
		if event.pressed:
			if not is_held:
				pickup()

func pickup():
	is_held = true
	freeze = true
	
	# 1. Bring to front visually
	z_index = 100
	
	# 2. Detach from sheep so it doesn't move with the sheep anymore
	if get_parent() != get_tree().current_scene:
		# We use reparent so it keeps its global position during the move
		call_deferred("reparent", get_tree().current_scene)

func drop():
	is_held = false
	freeze = false
	
	# 1. Reset visual depth
	z_index = 10
	
	# 2. Optional: Give it a tiny push so it doesn't just hang there
	apply_impulse(Vector2.ZERO)

func _physics_process(_delta):
	if is_held:
		# The ball follows the mouse perfectly
		global_position = get_global_mouse_position()
		
		# Reset velocity so it doesn't build up "gravity speed" while held
		linear_velocity = Vector2.ZERO
