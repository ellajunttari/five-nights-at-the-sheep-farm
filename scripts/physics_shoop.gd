extends RigidBody2D

var speed : float = 90.0
var move_direction = Vector2.ZERO

func _ready():
	lock_rotation = true
	# Connect the collision signal to ourselves
	body_entered.connect(_on_sheep_body_entered)
	_on_timer_timeout()

func _physics_process(_delta):
	if not freeze:
		if global_position.distance_to(get_global_mouse_position()) < 200:
			move_direction = (global_position - get_global_mouse_position()).normalized()
			speed = 200.0
		
		linear_velocity = move_direction * speed
	else:
		linear_velocity = Vector2.ZERO
		return

# This function runs the moment the sheep hits a wall
func _on_sheep_body_entered(body):
	# Only change direction if we are NOT scared of the mouse
	if global_position.distance_to(get_global_mouse_position()) >= 200:
		# Bounce off: Pick a new random direction
		choose_new_direction()
		print("Bounced off a wall!")

func _on_timer_timeout():
	var chance = randf_range(0, 100)
	if chance < 20:
		move_direction = Vector2.ZERO
		speed = 0.0
	else:
		choose_new_direction()

# I moved the random logic to its own function so we can call it anytime
func choose_new_direction():
	speed = randf_range(60.0, 100.0)
	move_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
