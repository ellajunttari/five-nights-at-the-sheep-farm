extends RigidBody2D

var speed : float = 90.0
var move_direction = Vector2.ZERO
var folder_path = "res://assets/sprites/Lamb/"
var animal_type = "sheep"

# Get a reference to the Sprite2D child node
@onready var sprite: Sprite2D = $Sprite2D 

#### Minttu Added #############

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
	var target_color = Color(1.2, 1.2, 1.2) if active else Color(1, 1, 1)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", target_scale, 0.1)
	tween.tween_property(self, "modulate", target_color, 0.1)
	
func _on_mouse_entered():
	var field = get_parent()
	# Check if we are in evening state before glowing
	if field.current_state == field.State.EVENING:
		# We use your existing set_highlight logic
		set_highlight(true)

func _on_mouse_exited():
	# Only turn off highlight if this animal isn't the one currently selected
	var field = get_parent()
	if field.sheep_to_confirm != self:
		set_highlight(false)
##################


func _ready():
	pick_sprite()
	sprite = get_node("Sprite2D")
	#sprite.texture = load("res://assets/sprites/sack_closed.png")
	lock_rotation = true
	# Connect the collision signal to ourselves
	body_entered.connect(_on_sheep_body_entered)
	_on_timer_timeout()
	
	# Minttu Added ###############3
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	##############
	
	
func pick_sprite():
	var dir = DirAccess.open(folder_path)
	if dir:
		var files: Array[String] = []
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			# Only grab files that end in .png (and ignore the .import files)
			if !dir.current_is_dir() and file_name.ends_with(".png"):
				files.append(file_name)
			file_name = dir.get_next()

		if files.size() > 0:
			var random_index = randi() % files.size()
			var final_path = folder_path + files[random_index]
			sprite.texture = load(final_path)
			sprite.z_index = 50
		else:
			print("No png files found in " + folder_path)
	else:
		print("An error occurred when trying to access the path.")

#func set_sheep_appearance(new_texture: Texture2D):
#	# 'sprite' is now a reference you can use anywhere in this script
#	sprite.texture = new_texture

func _physics_process(_delta):
	if not freeze:
		if global_position.distance_to(get_global_mouse_position()) < 200:
			move_direction = (global_position - get_global_mouse_position()).normalized()
			speed = 200.0
		
		linear_velocity = move_direction * speed
	else:
		linear_velocity = Vector2.ZERO

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
