extends RigidBody2D

var is_held = false
var can_be_picked_up = true # New variable

func _ready():
	# Ensure the wool doesn't fall off the sheep immediately
	freeze = true
	add_to_group("draggables")

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Check BOTH if it's not held AND if it's allowed to be picked up
			if not is_held and can_be_picked_up:
				pickup()

func pickup():
	if get_parent().name == "fur": 
		is_held = true
		freeze = true
		z_index = 100
		reparent.call_deferred(get_tree().current_scene)

func drop():
	is_held = false
	freeze = false
	z_index = 0
	
	# Disable future pick-ups
	can_be_picked_up = false 
	
	# Optional: Remove from the group so it's no longer "draggable"
	remove_from_group("draggables")

func _physics_process(_delta):
	if is_held:
		# The ball follows the mouse perfectly
		global_position = get_global_mouse_position()
		
		# Reset velocity so it doesn't build up "gravity speed" while held
		linear_velocity = Vector2.ZERO
