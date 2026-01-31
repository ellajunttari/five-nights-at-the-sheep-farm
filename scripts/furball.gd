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
			if not is_held and can_be_picked_up and not Global.is_mouse_busy:
				#Checks if player is able to pickup the furball
				if Global.picks_left > 0: 
					pickup()

func pickup():
	if get_parent().name == "fur": 
		Global.is_mouse_busy = true # Lock the mouse
		var fur = get_parent()
		var wolf = fur.get_parent()
		wolf.picked_fur += 1
		if wolf.picked_fur == 5:
			surprise()
		is_held = true
		freeze = true
		z_index = 100
		reparent.call_deferred(get_tree().current_scene)
		#reduce the global variable picks_left if its not 0
		if(Global.picks_left > 0): Global.picks_left -= 1
		
func surprise():
	print("surprise")

func drop():
	is_held = false
	freeze = false
	z_index = 0
	Global.is_mouse_busy = false
	
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
