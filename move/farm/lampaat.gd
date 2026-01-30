extends CharacterBody2D

# 1. Variables for movement
var speed : float = 90.0
var move_direction = Vector2.ZERO

func _ready():
	# Start the first move immediately
	_on_timer_timeout()
	#choose_new_direction()

func _physics_process(delta):
	
	if global_position.distance_to(get_global_mouse_position()) < 200:
		# Scared state: overrides the wander direction
		move_direction = (global_position - get_global_mouse_position()).normalized()
		speed = 200 
	else:
		# Calm state: uses the speed/direction from the Timer
		# No need to change move_direction here; it keeps the last random value
		pass 

	velocity = move_direction * speed
	move_and_slide()

func _on_timer_timeout():
	# 1. Roll a "dice" from 0 to 100
	var chance = randf_range(0, 100)
	
	# 2. 20% chance to stand still (Idle)
	if chance < 20:
		move_direction = Vector2.ZERO
		speed = 0
	# 3. 80% chance to walk
	else:
		speed = randf_range(60.0, 100.0)
		var random_x = randf_range(-1.0, 1.0)
		var random_y = randf_range(-1.0, 1.0)
		move_direction = Vector2(random_x, random_y).normalized()
