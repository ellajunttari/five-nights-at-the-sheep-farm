extends RigidBody2D

var speed : float = 90.0
var move_direction = Vector2.ZERO




# Code for picking up the one sheep
var is_selected = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var field = get_parent()
		if field.current_state == field.State.EVENING:
			field.show_selection_popup(self) # Tell the field we were clicked

func set_highlight(active: bool):
	is_selected = active
	var target_scale = Vector2(1.2, 1.2) if active else Vector2(1.0, 1.0)
	var target_color = Color(1.5, 1.5, 1.5) if active else Color(1, 1, 1)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", target_scale, 0.1)
	tween.tween_property(self, "modulate", target_color, 0.1)





func _ready():
	lock_rotation = true
	# Connect the collision signal to ourselves
	body_entered.connect(_on_sheep_body_entered)
	_on_timer_timeout()
	
	#need these for hover in evening state
	# Connect signals via code for a clean setup
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

#hover effect
func _on_mouse_entered():
	# Only pop/glow if the main game state is EVENING
	if get_parent().current_state == get_parent().State.EVENING:
		var tween = create_tween().set_parallel(true)
		# Pop Up
		tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_BACK)
		# Glow Effect (Modulate values > 1.0 make it brighter)
		tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2), 0.1)

func _on_mouse_exited():
	# Always return to normal size/color when mouse leaves
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
########


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
