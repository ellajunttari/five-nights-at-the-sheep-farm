extends Node2D

const WOLF_SCENE: PackedScene = preload("uid://cgxnugrgqgk3")
const SHEEP_SCENE: PackedScene = preload("uid://ivi1rrcsyx26")
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
var picks_left = 5
#current state
var current_state = State.MORNING
#How many sheep to delete
var delete_this_many_sheep = 0

############ Function ###############

#go to the next day
func next_day():
	_current_day += 1

func spawn_animal(animal_blueprint: PackedScene, count: int)-> void:
	# Get the center of the screen dynamically
	var screen_center = get_viewport_rect().size / 2
	
	for i in range(count):
		var animal = animal_blueprint.instantiate()
		add_child(animal)
		animal.position = screen_center + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		animal.scale = Vector2(0.1, 0.1)
		#if it was sheep, sheeps in den go up 1. Otherwise the wolf in den count goes up 1
		if (animal_blueprint == SHEEP_SCENE):
			sheeps_in += 1
		else:
			wolves_in += 1

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

#################################

func _ready() -> void:
	
	# Show what day it is
	var my_label = Label.new()
	my_label.text = "Day " + str(_current_day)
	add_child(my_label)
	my_label.position = Vector2(50, 50)
	
	current_state = State.MORNING

func _process(_delta):
	match current_state:
		State.MORNING:
			#delete sheep
			deleteSheep(delete_this_many_sheep)
			
			# spawn x sheep and x wolves
			spawn_animal(SHEEP_SCENE, spawn_this_many_sheep)
			spawn_animal(WOLF_SCENE, spawn_this_many_wolf)
			
			#When no more picks left, go to evening
			if (picks_left == 0):
				current_state = State.EVENING
			
		State.EVENING:
			# Logic for evening
			pass
		State.RESULT:
			# Show score screen
			pass
		State.END:
			# Game over logic
			pass
