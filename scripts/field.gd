extends Node2D

#Handles what state of a cycle it is
enum State {MORNING, EVENING, RESULT, END}

############# Variables #################

#how many days
var _current_day : int = 1
#is it morning or evening
var _is_morning : bool = true
#how many wolves have been found
var wolf_count : int = 0
#how many sheep in aitaus
var sheeps_in : int = 0
#how many wolves in aitaus
var wolves_in: int = 0
#how many sheep to spawn
var spawn_this_many_sheep: int = 0
#How many wolves to spawn
var spawn_this_many_wolf: int = 2
#how many picks left aka how many sacks left
var picks_left = Global.picks_left
#current state
var current_state = State.MORNING
#How many sheep to delete
var delete_this_many_sheep = 0

const SHEEP_SCENE = preload("uid://uhky4w4cihjo")
const WOLF_SCENE = preload("uid://c5yv0lc21wlup")

##Minttu Added##########
#Has morning started
var morning_started : bool = false
var evening_started : bool = false
var result_started : bool = false

var sheep_to_confirm = null
###########################

############ Function ###############

#go to the next day
func next_day():
	_current_day += 1
	

#function to delete sheeps
func deleteSheep(how_many):
	#reduce sheep count
	if (how_many != 0):
		sheeps_in -= how_many


#function to reduce picks
func reduce_picks():
	if (picks_left == 0):
		return
	picks_left -= 1
#function to restart picks
func restart_picks():
	picks_left = 5
	



## Minttu Added #########################
func fade_transition():
	var fade = $CanvasLayer/ColorRect # Make sure the path matches your scene
	
	# Fade to Black
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 1.5) # 0.5 seconds
	
	# Wait at black, then change state
	tween.tween_callback(func(): current_state = State.EVENING)
	tween.tween_callback(align_animal_in_line)
	
	tween.tween_interval(2.0)
	
	# Fade back to Transparent
	tween.tween_property(fade, "modulate:a", 0.0, 1.5)
	
func align_animal_in_line():
	var animal_list = get_tree().get_nodes_in_group("animal_group")
	var start_x = -390 # Where the line starts
	var start_y = -80 # The height of the line
	var x_spacing = 195  # Distance between each sheep horizontaly
	var y_spacing = 150 #Distance between rows vertically
	var max_columns = 5 #how many per row
	
	for i in range(animal_list.size()):
		var animal = animal_list[i]
		# Calculate grid position
		var column = i % max_columns # 0, 1, 2, 3, 4, then back to 0
		var row = i / max_columns    # 0 for first 5, 1 for next 5, etc.
		
		var target_pos = Vector2(
			start_x + (column * x_spacing), 
			start_y + (row * y_spacing)
		)
		# Move them instantly
		animal.global_position = target_pos
		# Ensure they stay still
		animal.linear_velocity = Vector2.ZERO


func show_selection_popup(selected):
	sheep_to_confirm = selected
	sheep_to_confirm.set_highlight(true) # Lock the glow
	$PickPopup.popup_centered()

func _on_popup_confirmed():
	current_state = State.RESULT
	fade_to_result()

func _on_popup_canceled():
	if sheep_to_confirm:
		sheep_to_confirm.set_highlight(false) # Turn off the glow
		sheep_to_confirm = null

func fade_to_result():
	var fade = $CanvasLayer/ColorRect
	var tween = create_tween()
	
	# 1. Fade to Black
	tween.tween_property(fade, "modulate:a", 1.0, 0.5)
	
	# 2. Change state and update text while screen is black
	tween.tween_callback(func(): 
		current_state = State.RESULT
		get_tree().call_group("animal_group", "hide")
		show_result_text()
	)
	
	# 3. Stay black briefly, then fade out
	tween.tween_interval(1.0)
	tween.tween_property(fade, "modulate:a", 0.0, 0.5)
	
func show_result_text():
	# If you have a specific Label for results, use that. 
	# Otherwise, we'll create a quick one.
	var result_label = Label.new()
	
	# Check if the chosen animal is a Wolf or a Sheep
	var result_type = "Sheep"
	if sheep_to_confirm.has_method("pick_sprite"): # Both have this, so let's check folder_path
		if "Wolf" in sheep_to_confirm.folder_path:
			result_type = "WOLF! Oh no!"
		else:
			result_type = "a normal Sheep. Phew!"
	
	result_label.text = "You chose: " + result_type
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(result_label)
	result_label.z_index = 999
	
	# Center it on screen
	result_label.position = Vector2(0, 0)
	result_label.z_index = 1000


#########################################

####################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Show what day it is
	var my_label = Label.new()
	my_label.text = "Day " + str(_current_day)
	add_child(my_label)
	my_label.position = Vector2(0, -270)
	my_label.z_index = 999
	
	##Minttu added
	$PickPopup.confirmed.connect(_on_popup_confirmed)
	$PickPopup.canceled.connect(_on_popup_canceled)
	##########
	
	

func spawn_multiple_rigidbodies(amount: int, type: String):
	for i in range(amount):
		# 1. Create the instance
		var new_body
		if type == "sheep":
			new_body = SHEEP_SCENE.instantiate()
			new_body.add_to_group("animal_group")
		else:
			new_body = WOLF_SCENE.instantiate()
			new_body.add_to_group("animal_group")
		
		# 2. Set a random position (so they don't overlap and explode)
		var random_pos = Vector2(randf_range(100, 500), randf_range(100, 300))
		new_body.position = random_pos
		new_body.z_index = 5
		# 3. Add to the scene
		add_child(new_body)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == State.MORNING:
		# Use a check so this only runs ONCE
		if not morning_started:
			spawn_multiple_rigidbodies(spawn_this_many_sheep, "sheep")
			spawn_multiple_rigidbodies(spawn_this_many_wolf, "wolf")
			morning_started = true
			
		# Constant checking (like your picks)
		if Global.picks_left == -1:
			current_state = State.EVENING
			morning_started = false # Reset the flag for tomorrow
			get_tree().call_group("animal_group", "set", "freeze", true)
			fade_transition()

	
	elif current_state == State.EVENING:
		if not evening_started:
			evening_started = true

	elif current_state == State.RESULT:
		if not result_started:
			result_started = true
	
	elif current_state == State.END:
		pass
