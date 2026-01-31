extends RigidBody2D

var is_held = false

func _ready():
	# Add this object to a group so the Side Object can find it later
	add_to_group("draggables")

func _input_event(viewport, event, shape_idx):
	# Detect click on the Wool to Pick it up
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_held:
			pickup()

func pickup():
	is_held = true
	freeze = true # Disable physics so we can move it manually
	
	# Detach from Sheep (reparent to root) so it moves freely
	if get_parent() != get_tree().current_scene:
		call_deferred("reparent", get_tree().current_scene)

# This function will be called remotely by the Side Object
func attempt_drop():
	if is_held:
		drop()

func drop():
	is_held = false
	freeze = false # Re-enable physics (gravity/collision)
	
	# Optional: Reset velocity if you want it to drop straight down
	linear_velocity = Vector2.ZERO

func _physics_process(delta):
	if is_held:
		# Smoothly follow the mouse
		global_position = get_global_mouse_position()
