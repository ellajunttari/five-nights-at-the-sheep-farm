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
var spawn_this_many_sheep: int = 2
#How many wolves to spawn
var spawn_this_many_wolf: int = 2
#how many picks left aka how many sacks left
var picks_left = Global.picks_left
#current state
var current_state = State.MORNING
#How many sheep to delete
var delete_this_many_sheep = 0
#Has morning started
var morning_started : bool = false

const SHEEP_SCENE = preload("uid://uhky4w4cihjo")

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

####################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Show what day it is
	var my_label = Label.new()
	my_label.text = "Day " + str(_current_day)
	add_child(my_label)
	my_label.position = Vector2(50, 50)
	my_label.z_index = 999
	morning_started = false
	

func spawn_multiple_rigidbodies(amount: int):
	for i in range(amount):
		# 1. Create the instance
		var new_body = SHEEP_SCENE.instantiate() 
		
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
			spawn_multiple_rigidbodies(3)
			morning_started = true
			
		# Constant checking (like your picks)
		if picks_left == 0:
			current_state = State.EVENING
			morning_started = false # Reset the flag for tomorrow
	
	elif current_state == State.EVENING:
		# Evening logic
		pass

	elif current_state == State.RESULT:
		pass
	
	elif current_state == State.END:
		pass
