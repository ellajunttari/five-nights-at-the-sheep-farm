extends RigidBody2D

var speed : float = 90.0
var move_direction = Vector2.ZERO
var folder_path = "res://assets/sprites/Wolf/"

# Get a reference to the Sprite2D child node
@onready var sprite: Sprite2D = $Sprite2D 

func _ready():
	pick_sprite()
	sprite = get_node("Sprite2D")
	#sprite.texture = load("res://assets/sprites/sack_closed.png")
	lock_rotation = true
	# Connect the collision signal to ourselves
	body_entered.connect(_on_sheep_body_entered)
	_on_timer_timeout()
	
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
